# CLAUDE.md

## Project Overview

This is the dot-ai documentation website built with Docusaurus.

## Documentation Structure

Documentation is **not stored permanently** in this repository. It is fetched from source repositories during CI/build time.

### Fetching Docs

Run the fetch script to pull latest documentation:

```bash
./scripts/fetch-docs.sh
```

This fetches docs from:
- `mcp` docs from https://github.com/vfarcic/dot-ai.git
- `controller` docs from https://github.com/vfarcic/dot-ai-controller.git

### Sidebar Configuration

The sidebar/index for documentation is configured in the `sidebars/` directory:
- `sidebars/mcp.ts` - MCP documentation sidebar
- `sidebars/controller.ts` - Controller documentation sidebar

**When a new doc page is added to dot-ai or dot-ai-controller**, you need to:
1. Run `./scripts/fetch-docs.sh` to get the new doc
2. Add the doc to the appropriate sidebar file in `sidebars/`

## Build Commands

- `npm run build` - Build the static site
- `npm ci` - Install dependencies
