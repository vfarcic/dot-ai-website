import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  mcpSidebar: [
    'index',
    'quick-start',
    {
      type: 'category',
      label: 'Setup',
      items: [
        'setup/mcp-setup',
        'setup/npx-setup',
        'setup/docker-setup',
        'setup/kubernetes-setup',
        'setup/kubernetes-toolhive-setup',
        'setup/kagent-setup',
      ],
    },
    {
      type: 'category',
      label: 'Guides',
      items: [
        'guides/mcp-tools-overview',
        'guides/mcp-recommendation-guide',
        'guides/mcp-remediate-guide',
        'guides/mcp-operate-guide',
        'guides/mcp-prompts-guide',
        'guides/mcp-project-setup-guide',
        'guides/mcp-capability-management-guide',
        'guides/organizational-data-concepts',
        'guides/pattern-management-guide',
        'guides/policy-management-guide',
        'guides/observability-guide',
        'guides/rest-api-gateway-guide',
      ],
    },
  ],
};

export default sidebars;
