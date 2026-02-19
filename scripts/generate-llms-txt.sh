#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$ROOT_DIR/docs"
STATIC_DIR="$ROOT_DIR/static"
BASE_URL="https://devopstoolkit.ai"

LLMS_TXT="$STATIC_DIR/llms.txt"
LLMS_FULL="$STATIC_DIR/llms-full.txt"
STATIC_DOCS="$STATIC_DIR/docs"

echo "Generating llms.txt and llms-full.txt..."

# ── Copy processed markdown files to static/ for .md URL serving ─────────
echo "Copying markdown files to static/docs/ ..."
rm -rf "$STATIC_DOCS"

# Section display names (order matches navbar)
SECTIONS="stack ai-engine mcp cli controller ui"
section_label() {
  case "$1" in
    stack)      echo "Getting Started" ;;
    ai-engine)  echo "AI Engine" ;;
    mcp)        echo "MCP" ;;
    cli)        echo "CLI" ;;
    controller) echo "Controller" ;;
    ui)         echo "Web UI" ;;
  esac
}

# Extract the first H1 title from a markdown file
get_title() {
  grep -m1 '^# ' "$1" 2>/dev/null | sed 's/^# //'
}

# Extract the first non-empty paragraph after the H1 as a description.
# Skips frontmatter, the title line, blank lines, headings, images, HTML comments,
# video embeds, and HR lines. Strips bold markers and inline markdown links.
get_description() {
  awk '
    BEGIN { found_title=0; in_frontmatter=0 }
    NR==1 && /^---$/ { in_frontmatter=1; next }
    in_frontmatter && /^---$/ { in_frontmatter=0; next }
    in_frontmatter { next }
    /^# / && !found_title { found_title=1; next }
    found_title && /^[[:space:]]*$/ { next }
    found_title && /^#/ { next }
    found_title && /^---/ { next }
    found_title && /^!\[/ { next }
    found_title && /^\[!\[/ { next }
    found_title && /^>/ { next }
    found_title && /^<!--/ { next }
    found_title {
      gsub(/\*\*/, "")
      # Strip markdown links [text](url) -> text
      while (match($0, /\[[^\]]*\]\([^)]*\)/)) {
        pre = substr($0, 1, RSTART - 1)
        link = substr($0, RSTART, RLENGTH)
        post = substr($0, RSTART + RLENGTH)
        # Extract text between [ and ]
        match(link, /\[[^\]]*\]/)
        text = substr(link, RSTART + 1, RLENGTH - 2)
        $0 = pre text post
      }
      print
      exit
    }
  ' "$1"
}

# Strip content that is not useful in plain-text LLM context
clean_content() {
  sed -e '/^---$/,/^---$/d' \
      -e '/<!-- docs-exclude-start -->/,/<!-- docs-exclude-end -->/d' \
      -e '/<!-- .* -->/d' \
      -e '/^!\[.*\](.*)/d' \
      "$1"
}

# Build .md URL from file path: docs/mcp/guides/foo.md -> /docs/mcp/guides/foo.md
# For index.md files: docs/stack/index.md -> /docs/stack/index.md
file_to_md_url() {
  rel="${1#$DOCS_DIR/}"            # mcp/guides/foo.md
  echo "$BASE_URL/docs/$rel"
}

# ── Copy markdown files to static/docs/ ──────────────────────────────────────

for section in $SECTIONS; do
  section_dir="$DOCS_DIR/$section"
  [ -d "$section_dir" ] || continue

  find "$section_dir" -name "*.md" -type f | while read -r f; do
    base=$(basename "$f")
    case "$base" in
      CHANGELOG.md) continue ;;
    esac
    rel="${f#$DOCS_DIR/}"
    target="$STATIC_DOCS/$rel"
    mkdir -p "$(dirname "$target")"
    # Copy with cleaned content (strip frontmatter, comments, images)
    clean_content "$f" > "$target"
  done
done

echo "Markdown files copied to static/docs/"

# ── Generate llms.txt ────────────────────────────────────────────────────────

cat > "$LLMS_TXT" << 'HEADER'
# DevOps AI Toolkit

> AI-powered Kubernetes operations for DevOps teams. Deploy, query, remediate, and operate Kubernetes resources through natural language using MCP, CLI, a Kubernetes controller, and a web UI.

DevOps AI Toolkit brings AI-powered intelligence to platform engineering, Kubernetes operations, and development workflows. Built on the Model Context Protocol (MCP), it integrates with Claude Code, Cursor, and VS Code for conversational DevOps automation.

- [Documentation](https://devopstoolkit.ai)
- [GitHub](https://github.com/vfarcic/dot-ai)

HEADER

for section in $SECTIONS; do
  section_dir="$DOCS_DIR/$section"
  [ -d "$section_dir" ] || continue

  label=$(section_label "$section")
  echo "## $label" >> "$LLMS_TXT"
  echo "" >> "$LLMS_TXT"

  # index file first
  if [ -f "$section_dir/index.md" ]; then
    title=$(get_title "$section_dir/index.md")
    url=$(file_to_md_url "$section_dir/index.md")
    desc=$(get_description "$section_dir/index.md")
    if [ -n "$desc" ]; then
      echo "- [$title]($url): $desc" >> "$LLMS_TXT"
    else
      echo "- [$title]($url)" >> "$LLMS_TXT"
    fi
  fi

  # remaining files (sorted, skip index.md and CHANGELOG.md)
  find "$section_dir" -name "*.md" -type f | sort | while read -r f; do
    base=$(basename "$f")
    case "$base" in
      index.md|CHANGELOG.md) continue ;;
    esac
    title=$(get_title "$f")
    [ -z "$title" ] && continue
    url=$(file_to_md_url "$f")
    desc=$(get_description "$f")
    if [ -n "$desc" ]; then
      echo "- [$title]($url): $desc" >> "$LLMS_TXT"
    else
      echo "- [$title]($url)" >> "$LLMS_TXT"
    fi
  done

  echo "" >> "$LLMS_TXT"
done

echo "Generated $LLMS_TXT"

# ── Generate llms-full.txt ───────────────────────────────────────────────────

cat > "$LLMS_FULL" << 'HEADER'
# DevOps AI Toolkit

> AI-powered Kubernetes operations for DevOps teams. Deploy, query, remediate, and operate Kubernetes resources through natural language using MCP, CLI, a Kubernetes controller, and a web UI.

HEADER

for section in $SECTIONS; do
  section_dir="$DOCS_DIR/$section"
  [ -d "$section_dir" ] || continue

  label=$(section_label "$section")
  echo "## $label" >> "$LLMS_FULL"
  echo "" >> "$LLMS_FULL"

  # index file first
  if [ -f "$section_dir/index.md" ]; then
    clean_content "$section_dir/index.md" >> "$LLMS_FULL"
    echo "" >> "$LLMS_FULL"
  fi

  # remaining files (sorted, skip index.md and CHANGELOG.md)
  find "$section_dir" -name "*.md" -type f | sort | while read -r f; do
    base=$(basename "$f")
    case "$base" in
      index.md|CHANGELOG.md) continue ;;
    esac
    clean_content "$f" >> "$LLMS_FULL"
    echo "" >> "$LLMS_FULL"
  done
done

echo "Generated $LLMS_FULL"
echo "Done generating LLM files."
