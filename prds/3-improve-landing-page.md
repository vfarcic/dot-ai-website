# PRD #3: Improve Landing Page

## Status: Draft

## Problem Statement

The current landing page is basic and doesn't effectively communicate the value proposition, features, or differentiation of the DevOps AI Toolkit. It consists of:
- A hero section with logo, title ("DevOps AI Toolkit"), and tagline ("AI-powered Kubernetes operations for DevOps teams")
- Two simple cards linking to MCP Server and Controller documentation

This doesn't give visitors a clear understanding of what the toolkit does, why they should use it, or how to get started.

## Proposed Solution

Redesign and enhance the landing page with better content, visual elements, and user engagement features.

### Key Design Decision to Discuss

**Option A: Use dot-ai repo README.md as landing page basis**
- The MCP server (dot-ai) is the primary product; controller is smaller and acts as support
- The README likely already contains well-crafted content about features, usage, and value proposition
- Would provide consistency between GitHub repo and website
- README content can be improved/expanded as part of this work

**Option B: Create new landing page content from scratch**
- More flexibility in design and structure
- Can be optimized specifically for marketing/conversion
- May diverge from README content over time

## Current State

**Landing page file**: `src/pages/index.tsx`
- `HomepageHeader`: Hero banner with logo, title, tagline
- `ProjectsSection`: Two cards for MCP Server and Controller docs

**Styling**: `src/pages/index.module.css`
- Yellow (#FACB00) hero banner background
- Basic responsive layout

## Open Questions (To Discuss When Starting)

1. Should we use the dot-ai README.md as the landing page content?
2. What sections/features should the landing page include?
   - Feature highlights?
   - Getting started quick guide?
   - Demo/screenshots?
   - Testimonials/social proof?
   - Comparison with alternatives?
3. Should the Controller be prominently featured or treated as secondary?
4. What call-to-action should be primary? (Docs, GitHub, Installation)
5. Any specific visual/design requirements?

## Success Criteria

- [ ] Landing page clearly communicates what DevOps AI Toolkit does
- [ ] Visitors understand the value proposition within seconds
- [ ] Clear path to getting started
- [ ] Mobile-responsive design maintained
- [ ] Page loads quickly (no heavy assets)

## Milestones

- [ ] Finalize landing page content strategy (README-based vs. new content)
- [ ] Define page structure and sections
- [ ] Implement new landing page design
- [ ] Review and iterate based on feedback
- [ ] Deploy to production

## Progress Log

| Date | Update |
|------|--------|
| 2025-12-17 | PRD created as placeholder for future discussion |

## References

- GitHub Issue: [#3](https://github.com/vfarcic/dot-ai-website/issues/3)
- Current landing page: `src/pages/index.tsx`
- dot-ai repo: https://github.com/vfarcic/dot-ai
