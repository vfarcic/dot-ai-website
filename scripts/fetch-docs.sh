#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$ROOT_DIR/docs"
TEMP_DIR="$ROOT_DIR/.temp-repos"

echo "Fetching documentation from source repositories..."

# Create temp directory
mkdir -p "$TEMP_DIR"

# Resolve a relative path against a base directory, purely lexically.
# Prints the normalized path; returns 1 if the path escapes the repository root.
resolve_path() {
  base="$1"
  rel="$2"

  # Combine first: field splitting applies only to the expanded text, so
  # "$base/$rel" would keep the literal slash glued to the adjacent components.
  combined="$base/$rel"

  set -f
  OLD_IFS="$IFS"
  IFS='/'
  out=''
  for part in $combined; do
    case "$part" in
      ''|.)
        ;;
      ..)
        if [ -z "$out" ]; then
          IFS="$OLD_IFS"
          set +f
          return 1
        fi
        case "$out" in
          */*) out="${out%/*}" ;;
          *) out='' ;;
        esac
        ;;
      *)
        out="${out:+$out/}$part"
        ;;
    esac
  done
  IFS="$OLD_IFS"
  set +f

  printf '%s' "$out"
}

# Function to rewrite links that point outside the published docs tree
#
# Developer guides, governance files and anything removed below are never copied
# to the website, so a relative link to one fails the Docusaurus broken-link
# check and breaks the build. Point those at the source repository on GitHub
# instead, so the link still resolves for the reader.
rewrite_unpublished_links() {
  file="$1"
  src_rel="$2"
  repo_root="$3"
  src_prefix="$4"
  target_dir="$5"
  blob_base="$6"

  [ -n "$blob_base" ] || return 0

  case "$src_rel" in
    */*) src_dir="${src_rel%/*}" ;;
    *) src_dir='' ;;
  esac

  grep -o ']([^)]*\.md[^)]*)' "$file" 2>/dev/null | sort -u | while read -r match; do
    link="${match#](}"
    link="${link%)}"

    # Leave external, absolute and anchor-only links alone
    case "$link" in
      *://*|/*|'#'*|mailto:*) continue ;;
    esac

    link_path="${link%%#*}"
    link_anchor="${link#"$link_path"}"

    resolved="$(resolve_path "$src_dir" "$link_path")" || continue
    [ -n "$resolved" ] || continue

    # Still published on the website? Keep the relative link.
    case "$resolved" in
      "$src_prefix"/*)
        if [ -e "$target_dir/${resolved#"$src_prefix"/}" ]; then
          continue
        fi
        ;;
    esac

    # Only rewrite what actually exists in the source repository, so a genuine
    # typo keeps failing the build instead of becoming a dead GitHub link.
    [ -e "$repo_root/$resolved" ] || continue

    old="$(printf '%s' "$match" | sed 's/[][\\.*^$|]/\\&/g')"
    new="$(printf '%s' "](${blob_base}/${resolved}${link_anchor})" | sed 's/[\\&|]/\\&/g')"

    temp_file="${file}.tmp"
    sed "s|$old|$new|g" "$file" > "$temp_file"
    mv "$temp_file" "$file"

    echo "  Rewrote unpublished link $link -> $blob_base/$resolved"
  done
}

# Function to process markdown files and remove docs-exclude markers
process_markdown() {
  file="$1"
  src_rel="$2"
  repo_root="$3"
  src_prefix="$4"
  target_dir="$5"
  blob_base="$6"

  # Create a temp file for processing
  temp_file="${file}.tmp"

  # Use sed to:
  # 1. Remove multi-line blocks: <!-- docs-exclude-start --> ... <!-- docs-exclude-end -->
  # 2. Remove single-line markers: <!-- docs-exclude -->...
  # 3. Convert absolute devopstoolkit.ai URLs to relative paths (so they don't open in new tab)
  sed -e '/<!-- docs-exclude-start -->/,/<!-- docs-exclude-end -->/d' \
      -e '/<!-- docs-exclude -->/d' \
      -e 's|https://devopstoolkit\.ai/docs/|/docs/|g' \
      -e 's|https://devopstoolkit\.ai|/|g' \
      "$file" > "$temp_file"

  mv "$temp_file" "$file"

  rewrite_unpublished_links "$file" "$src_rel" "$repo_root" "$src_prefix" \
    "$target_dir" "$blob_base"
}

# Function to fetch docs from a repo
fetch_docs() {
  project="$1"
  repo_url="$2"
  docs_path="$3"
  target_dir="$DOCS_DIR/$project"
  temp_repo="$TEMP_DIR/$project"
  blob_base="$(printf '%s' "$repo_url" | sed 's|\.git$||')/blob/main"

  echo ""
  echo "=== Processing $project ==="
  echo "Repository: $repo_url"
  echo "Docs path: $docs_path"

  # Clone or pull the repository
  if [ -d "$temp_repo" ]; then
    echo "Updating existing clone..."
    cd "$temp_repo"
    git fetch origin
    git reset --hard origin/main
    cd "$ROOT_DIR"
  else
    echo "Cloning repository..."
    git clone --depth 1 "$repo_url" "$temp_repo"
  fi

  # Check if docs directory exists in the repo
  if [ -d "$temp_repo/$docs_path" ]; then
    echo "Copying docs to $target_dir..."
    rm -rf "$target_dir"
    mkdir -p "$target_dir"
    cp -r "$temp_repo/$docs_path/"* "$target_dir/"

    # Remove non-user-facing docs (governance/contributor docs, dev-only docs)
    echo "Removing non-user-facing docs..."
    rm -f "$target_dir/GOVERNANCE.md"
    rm -f "$target_dir/MAINTAINERS.md"
    rm -f "$target_dir/ROADMAP.md"
    rm -f "$target_dir/CLAUDE.md"
    rm -rf "$target_dir/dev"

    # Process all markdown files to remove docs-exclude markers
    echo "Processing markdown files..."
    find "$target_dir" -name "*.md" -type f | while read -r md_file; do
      process_markdown "$md_file" "$docs_path/${md_file#"$target_dir"/}" \
        "$temp_repo" "$docs_path" "$target_dir" "$blob_base"
    done

    echo "Done processing $project docs."
  else
    echo "Warning: No docs directory found at $temp_repo/$docs_path"
    echo "Creating placeholder..."
    mkdir -p "$target_dir"
    cat > "$target_dir/index.md" << EOF
---
sidebar_position: 1
---

# $project

Documentation coming soon.
EOF
  fi
}

# Fetch dot-ai docs (split into ai-engine and mcp sections)
echo ""
echo "=== Processing dot-ai (ai-engine + mcp) ==="
DOTAI_REPO="https://github.com/vfarcic/dot-ai.git"
DOTAI_TEMP="$TEMP_DIR/dot-ai"
DOTAI_BLOB="$(printf '%s' "$DOTAI_REPO" | sed 's|\.git$||')/blob/main"

if [ -d "$DOTAI_TEMP" ]; then
  echo "Updating existing clone..."
  cd "$DOTAI_TEMP"
  git fetch origin
  git reset --hard origin/main
  cd "$ROOT_DIR"
else
  echo "Cloning repository..."
  git clone --depth 1 "$DOTAI_REPO" "$DOTAI_TEMP"
fi

for section in ai-engine mcp; do
  target_dir="$DOCS_DIR/$section"
  if [ -d "$DOTAI_TEMP/docs/$section" ]; then
    echo "Copying $section docs to $target_dir..."
    rm -rf "$target_dir"
    mkdir -p "$target_dir"
    cp -r "$DOTAI_TEMP/docs/$section/"* "$target_dir/"

    echo "Removing non-user-facing docs from $section..."
    rm -f "$target_dir/GOVERNANCE.md"
    rm -f "$target_dir/MAINTAINERS.md"
    rm -f "$target_dir/ROADMAP.md"
    rm -f "$target_dir/CLAUDE.md"
    rm -rf "$target_dir/dev"

    echo "Processing markdown files in $section..."
    find "$target_dir" -name "*.md" -type f | while read -r md_file; do
      process_markdown "$md_file" "docs/$section/${md_file#"$target_dir"/}" \
        "$DOTAI_TEMP" "docs/$section" "$target_dir" "$DOTAI_BLOB"
    done

    echo "Done processing $section docs."
  else
    echo "Warning: No docs directory found at $DOTAI_TEMP/docs/$section"
  fi
done

# Fetch docs from other repositories
fetch_docs "cli" "https://github.com/vfarcic/dot-ai-cli.git" "docs"
fetch_docs "controller" "https://github.com/vfarcic/dot-ai-controller.git" "docs"
fetch_docs "ui" "https://github.com/vfarcic/dot-ai-ui.git" "docs"
fetch_docs "stack" "https://github.com/vfarcic/dot-ai-stack.git" "docs"
fetch_docs "headlamp" "https://github.com/vfarcic/dot-ai-headlamp.git" "docs"

echo ""
echo "=== Cleanup ==="
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up."

echo ""
echo "=== Generating llms.txt ==="
"$SCRIPT_DIR/generate-llms-txt.sh"

echo ""
echo "Documentation fetch complete!"
