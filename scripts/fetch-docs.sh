#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$ROOT_DIR/docs"
TEMP_DIR="$ROOT_DIR/.temp-repos"

echo "Fetching documentation from source repositories..."

# Create temp directory
mkdir -p "$TEMP_DIR"

# Function to process markdown files and remove docs-exclude markers
process_markdown() {
  file="$1"

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
}

# Function to fetch docs from a repo
fetch_docs() {
  project="$1"
  repo_url="$2"
  docs_path="$3"
  target_dir="$DOCS_DIR/$project"
  temp_repo="$TEMP_DIR/$project"

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
      process_markdown "$md_file"
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
      process_markdown "$md_file"
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

echo ""
echo "=== Cleanup ==="
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up."

echo ""
echo "=== Generating llms.txt ==="
"$SCRIPT_DIR/generate-llms-txt.sh"

echo ""
echo "Documentation fetch complete!"
