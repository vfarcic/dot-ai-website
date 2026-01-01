import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  uiSidebar: [
    'index',
    {
      type: 'category',
      label: 'Setup',
      items: [
        'setup/kubernetes-setup',
      ],
    },
  ],
};

export default sidebars;
