// Docusaurus configuration for DevOps AI Toolkit documentation portal
import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'DevOps AI Toolkit',
  tagline: 'AI-powered Kubernetes operations for DevOps teams',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  // Enable Mermaid diagrams
  markdown: {
    mermaid: true,
  },
  themes: ['@docusaurus/theme-mermaid'],

  url: 'https://devopstoolkit.ai',
  baseUrl: '/',

  organizationName: 'vfarcic',
  projectName: 'dot-ai-website',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  plugins: [
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'mcp',
        path: 'docs/mcp',
        routeBasePath: 'docs/mcp',
        sidebarPath: './sidebars/mcp.ts',
        editUrl: 'https://github.com/vfarcic/dot-ai/tree/main/docs/',
      },
    ],
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'controller',
        path: 'docs/controller',
        routeBasePath: 'docs/controller',
        sidebarPath: './sidebars/controller.ts',
        editUrl: 'https://github.com/vfarcic/dot-ai-controller/tree/main/docs/',
      },
    ],
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      {
        hashed: true,
        docsRouteBasePath: ['/docs/mcp', '/docs/controller'],
        docsDir: ['docs/mcp', 'docs/controller'],
        docsPluginIdForPreferredVersion: 'mcp',
        indexBlog: false,
        highlightSearchTermsOnTargetPage: true,
        searchBarShortcutHint: false,
      },
    ],
  ],

  presets: [
    [
      'classic',
      {
        docs: false, // Disable default docs, we use multi-instance above
        blog: false, // Disable blog for now
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/social-card.jpg',
    colorMode: {
      defaultMode: 'dark',
      disableSwitch: true,
      respectPrefersColorScheme: false,
    },
    navbar: {
      title: 'DevOps AI Toolkit',
      logo: {
        alt: 'DevOps AI Toolkit Logo',
        src: 'img/logo.jpeg',
        style: { borderRadius: '4px' },
      },
      items: [
        {
          to: '/docs/mcp',
          label: 'MCP Server',
          position: 'left',
        },
        {
          to: '/docs/controller',
          label: 'Controller',
          position: 'left',
        },
        {
          type: 'dropdown',
          label: 'GitHub',
          position: 'right',
          items: [
            {
              href: 'https://github.com/vfarcic/dot-ai',
              label: 'MCP Server',
            },
            {
              href: 'https://github.com/vfarcic/dot-ai-controller',
              label: 'Controller',
            },
          ],
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Documentation',
          items: [
            {
              label: 'MCP Server',
              to: '/docs/mcp',
            },
            {
              label: 'Controller',
              to: '/docs/controller',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'MCP Server Discussions',
              href: 'https://github.com/vfarcic/dot-ai/discussions',
            },
            {
              label: 'Controller Discussions',
              href: 'https://github.com/vfarcic/dot-ai-controller/discussions',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'MCP Server GitHub',
              href: 'https://github.com/vfarcic/dot-ai',
            },
            {
              label: 'Controller GitHub',
              href: 'https://github.com/vfarcic/dot-ai-controller',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} DevOps AI Toolkit. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['bash', 'yaml', 'json'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
