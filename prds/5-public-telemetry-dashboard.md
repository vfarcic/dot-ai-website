# PRD #5: Public Telemetry Dashboard

**GitHub Issue**: [#5](https://github.com/vfarcic/dot-ai-website/issues/5)
**Status**: Draft
**Priority**: Medium
**Created**: 2026-01-20

---

## Problem Statement

dot-ai MCP server collects anonymous telemetry via PostHog (implemented in [dot-ai PRD #329](https://github.com/vfarcic/dot-ai/blob/main/prds/329-posthog-telemetry.md)), but users have no visibility into this data. This creates several issues:

1. **Lack of transparency**: Users don't know what data is actually being collected
2. **Trust deficit**: Without seeing the data, users may be skeptical about privacy claims
3. **Missed engagement**: Usage stats could demonstrate project health and attract contributors
4. **No social proof**: Potential users can't see adoption metrics before trying the tool

## Solution Overview

Create a public telemetry visualization page on the dot-ai website that displays aggregated, anonymous usage metrics. This page will:

1. Show real usage data from PostHog (tool usage, provider distribution, adoption trends)
2. Reinforce privacy commitments by demonstrating what IS collected (proving what ISN'T)
3. Provide social proof through adoption metrics
4. Build trust through radical transparency

## User Impact

### For Potential Users
- See project health and adoption before trying
- Understand exactly what telemetry is collected
- Build confidence in privacy commitments

### For Existing Users
- Transparency into how their anonymous data contributes to insights
- See community-wide usage patterns
- Validate that no PII is collected

### For Contributors
- Understand which tools need improvement (high error rates)
- See which AI providers to prioritize
- Data-driven contribution decisions

## Technical Scope

### Data to Display

Based on the PostHog dashboard created in dot-ai PRD #329:

| Metric | Visualization | Purpose |
|--------|---------------|---------|
| Tool Usage Distribution | Bar chart | Show which tools are most used |
| AI Provider Distribution | Pie chart | Show provider popularity |
| MCP Client Distribution | Pie chart | Show which agents use dot-ai |
| Daily Active Instances | Line chart | Show adoption trends |
| Total Tool Executions | Counter | Social proof metric |
| Kubernetes Versions | Table | Environment context |

### Data Access Options (Decision Required)

Three approaches to consider during implementation:

1. **PostHog API Direct** - Query PostHog API from website, build custom React visualizations
   - Pros: Live data, full control over styling
   - Cons: More development work, API key management

2. **Public PostHog Dashboard Link** - Link to shared PostHog dashboard
   - Pros: Zero development, always current
   - Cons: Users leave site, PostHog branding

3. **Static Data with CI Refresh** - Export data during CI builds, render static charts
   - Pros: Fast loading, no runtime API calls
   - Cons: Data staleness (updated on builds only)

### Integration Points

- **Docusaurus**: Website framework - need React component for visualization page
- **PostHog**: Data source - need API access or embed strategy
- **CI/CD**: If using static approach, need build-time data fetching

## Success Criteria

1. **Page live**: Telemetry visualization page accessible at `/telemetry` or `/stats`
2. **Data accurate**: Metrics match PostHog dashboard within acceptable lag
3. **Privacy reinforced**: Page clearly explains what's collected and what's NOT
4. **Mobile responsive**: Charts readable on mobile devices
5. **Performance acceptable**: Page loads in under 3 seconds

## Implementation Milestones

- [ ] **M1: Design decision on data access approach** - Evaluate PostHog API vs embeds vs static export, document decision with rationale
- [ ] **M2: Page scaffold and routing** - Create the telemetry page in Docusaurus with basic layout and navigation
- [ ] **M3: Data integration** - Implement chosen data access approach (API client, embeds, or CI export)
- [ ] **M4: Visualization components** - Build/integrate chart components for each metric
- [ ] **M5: Privacy messaging** - Add clear section explaining telemetry transparency (link to telemetry guide)
- [ ] **M6: Testing and polish** - Mobile responsiveness, loading states, error handling

## Dependencies

- **PostHog account access**: Need API key or public dashboard configuration
- **dot-ai telemetry live**: Requires dot-ai PRD #329 deployed and collecting data (DONE)
- **Telemetry guide published**: Link to docs for full transparency details

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Low data volume initially | Empty-looking charts | Show "early adopter" messaging, focus on trends not absolutes |
| PostHog API rate limits | Page errors | Cache data, use static approach if needed |
| Data interpretation issues | User confusion | Add context/explanations to each metric |
| Maintenance burden | Stale page | Automate data refresh, keep design simple |

## Alternatives Considered

1. **No public dashboard**: Misses transparency opportunity
2. **Blog posts with screenshots**: Manual, quickly outdated
3. **Third-party analytics embed (Plausible, etc.)**: Different data source than actual telemetry

## Design Decisions

| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| | | | |

## Progress Log

| Date | Update |
|------|--------|
| 2026-01-20 | PRD created |

---

## Appendix: Related Resources

- [dot-ai PRD #329: PostHog Telemetry](https://github.com/vfarcic/dot-ai/blob/main/prds/329-posthog-telemetry.md)
- [Telemetry Guide](https://dot-ai.io/docs/mcp/guides/telemetry-guide) (once published)
- [PostHog Dashboard](https://app.posthog.com/) (internal link)
