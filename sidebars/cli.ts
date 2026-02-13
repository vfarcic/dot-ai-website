import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  cliSidebar: [
    'index',
    'quick-start',
    {
      type: 'category',
      label: 'Setup',
      items: [
        'setup/installation',
        'setup/configuration',
        'setup/shell-completion',
      ],
    },
    {
      type: 'category',
      label: 'Guides',
      items: [
        'guides/cli-commands-overview',
        'guides/skills-generation',
        'guides/output-formats',
        'guides/automation',
      ],
    },
  ],
};

export default sidebars;
