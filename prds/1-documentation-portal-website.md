# PRD: Documentation Portal Website

**GitHub Issue**: [#1](https://github.com/vfarcic/dot-ai-website/issues/1)

## Overview

### Problem Statement
The DevOps AI Toolkit ecosystem consists of multiple projects (dot-ai MCP, dot-ai-controller, and potentially future additions) with documentation scattered across separate repositories. Users have no unified place to discover, explore, and learn about the toolkit. Each repo maintains its own docs without a user-friendly interface, making it difficult for potential users to understand the ecosystem and get started.

### Solution Summary
Create a Docusaurus-based documentation portal website that:
- Aggregates documentation from multiple source repositories at build time
- Provides a compelling landing page showcasing the ecosystem
- Offers unified navigation across all project documentation
- Lives in its own repository to keep source repos focused on code
- Automates deployment via CI/CD pipeline

### Architecture Decision
Based on evaluation of static site generators (Docusaurus, Hugo, MkDocs, VitePress, Docsify), **Docusaurus** was selected for:
- Native multi-docs instance support (one sidebar per project)
- Strong CNCF adoption (Kubernetes, Helm, Flux, Dapr)
- Excellent landing page flexibility with React
- Built-in search capability
- Future-proof features (versioning, i18n)

### Target Users
- **Primary**: End users evaluating or adopting the DevOps AI Toolkit
- **Secondary**: Contributors looking to understand the ecosystem
- **Tertiary**: CNCF reviewers and open source community members

### Success Criteria
- [ ] Professional website live and publicly accessible
- [ ] Documentation from dot-ai integrated and navigable
- [ ] Documentation from dot-ai-controller integrated and navigable
- [ ] Compelling landing page with clear value proposition
- [ ] Automated deployment on documentation changes
- [ ] Mobile-responsive design
- [ ] Fast load times (Lighthouse performance > 90)
- [ ] Easy to add future projects to the portal

## Technical Architecture

### Multi-Repository Strategy

```
dot-ai-website/           # This repository
├── docusaurus.config.js
├── sidebars/
│   ├── mcp.js            # Sidebar for dot-ai docs
│   └── controller.js     # Sidebar for controller docs
├── src/
│   └── pages/
│       └── index.js      # Landing page
├── docs/                 # Populated at build time
│   ├── mcp/              # ← fetched from vfarcic/dot-ai/docs
│   └── controller/       # ← fetched from vfarcic/dot-ai-controller/docs
├── scripts/
│   └── fetch-docs.sh     # Pulls docs from source repos
└── .github/workflows/
    └── deploy.yml        # Build and deploy workflow
```

### Source Repositories

| Project | Repository | Docs Path |
|---------|------------|-----------|
| MCP Server | `vfarcic/dot-ai` | `docs/` |
| Controller | `vfarcic/dot-ai-controller` | `docs/` |
| Future projects | TBD | TBD |

### Build Flow

```
1. CI triggers (webhook, schedule, or manual)
2. fetch-docs.sh clones/pulls latest from source repos
3. Docs copied to website/docs/{project}/
4. Docusaurus builds static site
5. Deploy to GitHub Pages
```

### Linking Strategy
- Links within source repo docs should point to the website URLs
- Format: `https://[website-domain]/docs/mcp/quick-start`
- Source repos update their doc links to point to website

### Issue Tracking
- Documentation content bugs → File in source repo (dot-ai, dot-ai-controller)
- Website/portal bugs → File in dot-ai-website

## User Experience

### Information Architecture

```
Landing Page
├── Hero Section
│   ├── Ecosystem tagline
│   ├── Key value proposition
│   └── Primary CTA (Get Started)
├── Projects Overview
│   ├── dot-ai MCP (with link to docs)
│   └── dot-ai-controller (with link to docs)
├── Features Highlights
│   ├── AI-Powered Recommendations
│   ├── Cluster Discovery
│   ├── Remediation
│   └── Autonomous Operations
├── Quick Start Preview
└── Community Section
    ├── GitHub links
    └── Contributing info

Documentation Portal
├── MCP Server Docs
│   ├── Getting Started
│   ├── Setup Guides
│   ├── Tools Reference
│   ├── Prompts Guide
│   └── Contributing
└── Controller Docs
    ├── Overview
    ├── Installation
    ├── Configuration
    └── Usage
```

### User Journeys

#### New User Discovery
```
Landing Page → Understand ecosystem → Choose project → Quick Start → First success
```

#### Existing User Reference
```
Documentation search → Find specific guide → Follow instructions
```

#### Contributor Journey
```
Landing Page → Project docs → Contributing guide → Development setup
```

## Implementation Plan

### Milestone 1: Project Setup & Basic Structure
**Goal**: Docusaurus project initialized with multi-docs configuration

**Tasks**:
- Initialize Docusaurus project
- Configure multi-docs instances (mcp, controller)
- Set up project structure (sidebars, scripts)
- Configure local development environment
- Create fetch-docs script for pulling from source repos

**Validation**:
- [x] Local dev server runs successfully
- [x] Multi-docs structure configured
- [x] fetch-docs script pulls from both source repos

### Milestone 2: Landing Page
**Goal**: Compelling homepage showcasing the ecosystem

**Tasks**:
- Design and implement hero section
- Create projects overview section
- Add features highlights
- Implement responsive design
- Add navigation to documentation sections

**Validation**:
- [ ] Landing page visually appealing
- [x] Clear value proposition communicated
- [x] Navigation to docs works
- [ ] Mobile-responsive verified

### Milestone 3: Documentation Integration
**Goal**: All source repo docs integrated and navigable

**Tasks**:
- Integrate dot-ai documentation
- Integrate dot-ai-controller documentation
- Configure sidebars for each project
- Set up cross-project navigation
- Add search functionality
- Test all documentation pages

**Validation**:
- [ ] All dot-ai docs accessible
- [ ] All dot-ai-controller docs accessible
- [ ] Search works across all docs
- [ ] No broken links or images

### Milestone 4: CI/CD & Deployment
**Goal**: Automated build and deployment pipeline

**Tasks**:
- Configure GitHub Pages deployment
- Create deployment workflow (fetch → build → deploy)
- Set up build triggers (push, manual, webhook consideration)
- Enable HTTPS
- Test deployment process

**Validation**:
- [ ] Website publicly accessible
- [ ] Automated deployment working
- [ ] HTTPS enabled
- [ ] Build completes successfully

### Milestone 5: Polish & Launch
**Goal**: Production-ready website

**Tasks**:
- SEO optimization (meta tags, sitemap)
- Performance optimization
- Add analytics (optional)
- Final testing across browsers/devices
- Update source repo READMEs with website link
- Announce availability

**Validation**:
- [ ] Lighthouse score > 90
- [ ] SEO meta tags on all pages
- [ ] Cross-browser testing passed
- [ ] Source repos updated with website link

## Future Considerations

### AI-Powered Documentation Testing (Placeholder)
A future tool in the dot-ai MCP that would:
- Validate documentation clarity and completeness using AI
- Functionally test documentation by executing instructions
- Run as part of CI to catch outdated or broken docs
- **Status**: To be discussed and specified in separate PRD after website launch

### Versioned Documentation
- Currently: Docs represent latest version of each project
- Future: Consider versioned docs aligned with releases
- **Status**: Deferred, revisit based on user needs

### Sync Mechanism
- Currently: Manual or scheduled rebuilds
- Future: Webhook-based triggers from source repos
- **Status**: Decide during Milestone 4 implementation

### Additional Projects
- Architecture supports adding more projects
- Add new fetch target + docs instance + sidebar
- **Status**: Ready when new projects join ecosystem

## Dependencies

### Internal Dependencies
- dot-ai repository documentation (docs/)
- dot-ai-controller repository documentation (docs/)
- GitHub repository permissions for GitHub Pages

### External Dependencies
- Docusaurus framework
- Node.js runtime
- GitHub Actions for CI/CD
- GitHub Pages for hosting

## Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Source docs require significant changes | Medium | Low | Audit docs early, Docusaurus handles standard markdown well |
| Build complexity with multi-repo fetch | Medium | Medium | Start simple (clone + copy), optimize later |
| Sync delays between doc changes and website | Low | High | Document expected delay, consider webhooks later |
| Cross-project link maintenance | Medium | Medium | Establish URL conventions early, document linking strategy |

## Open Questions

1. **Custom domain**: Use GitHub Pages default or custom domain?
2. **Analytics**: Include website analytics? Privacy considerations?
3. **Webhook triggers**: Implement for Milestone 4 or defer?
4. **Algolia search**: Use built-in search or integrate Algolia DocSearch?

## Related PRDs

- **dot-ai #179**: Original website PRD (superseded by this multi-repo approach)
- **dot-ai #173**: CNCF Foundation Submission - Website supports CNCF evaluation

## Progress Log

### 2025-12-10 - Milestone 1 Complete + Milestone 2 Partial
**Completed**:
- Initialized Docusaurus 3.9.2 project with TypeScript
- Configured multi-docs instances (mcp, controller) via plugins
- Created sidebars (`sidebars/mcp.ts`, `sidebars/controller.ts`)
- Created `scripts/fetch-docs.sh` with docs-exclude marker support for stripping GitHub-specific content
- Implemented landing page with hero section and project cards
- Added Playwright MCP for browser-based testing
- Verified local dev server and navigation via Playwright

**Decisions Made**:
- URL: `https://devopstoolkit.ai`
- No hardcoded feature list on landing page (to avoid outdated content)
- Source repos use `<!-- docs-exclude-start/end -->` markers to strip badges/images for docs portal
- README.md copied as `intro.md` during fetch

**Blocked**:
- Docs integration blocked until source repos add docs-exclude markers around badges/logo

**Next**: Source repos need to add docs-exclude markers, then continue with Milestone 3

### [Date] - PRD Created
- Created dot-ai-website repository
- Initial PRD with 5 major milestones
- Architecture based on discussion in dot-ai #179
- Ready for implementation

---

**Last Updated**: 2025-12-10
**Status**: In Progress (Milestone 1 complete, Milestone 2 partial)
**Next Action**: Add docs-exclude markers to source repos, then continue Milestone 3
