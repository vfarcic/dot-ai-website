# Generate Logo Prompt

Generate an image generation AI prompt for a new project logo that matches the existing style.

## Instructions

1. Determine what the logo is for by:
   - Checking recent conversation context for what feature/component is being added
   - Looking at recent file changes (especially in `docusaurus.config.ts`, `sidebars/`, or `src/pages/`)
   - If unclear, ask the user: "What is this logo for?"

2. Generate a prompt in this format (assumes `static/img/logo.jpeg` is attached):

```
Match the exact style of the attached image.

Create a minimalist flat vector icon:
- Solid yellow background (#FACB00)
- Dark charcoal icon (#2D2D2D)
- Two-tone only, no gradients, no shadows, no 3D effects
- Clean geometric shapes with technical/DevOps aesthetic
- Square format
- No text

Subject: [DESCRIPTION based on what the logo represents]

The icon should convey: [CONCEPT - e.g., "getting started", "deployment", "unified stack"]
```
