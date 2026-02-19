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

  headTags: [
    {
      tagName: 'link',
      attributes: {
        rel: 'alternate',
        type: 'text/plain',
        href: '/llms.txt',
        title: 'LLM-friendly site index',
      },
    },
    {
      tagName: 'link',
      attributes: {
        rel: 'alternate',
        type: 'text/plain',
        href: '/llms-full.txt',
        title: 'LLM-friendly full documentation',
      },
    },
  ],

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
        id: 'ai-engine',
        path: 'docs/ai-engine',
        routeBasePath: 'docs/ai-engine',
        sidebarPath: './sidebars/ai-engine.ts',
        editUrl: 'https://github.com/vfarcic/dot-ai/tree/main/docs/ai-engine/',
      },
    ],
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'mcp',
        path: 'docs/mcp',
        routeBasePath: 'docs/mcp',
        sidebarPath: './sidebars/mcp.ts',
        editUrl: 'https://github.com/vfarcic/dot-ai/tree/main/docs/mcp/',
      },
    ],
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'cli',
        path: 'docs/cli',
        routeBasePath: 'docs/cli',
        sidebarPath: './sidebars/cli.ts',
        editUrl: 'https://github.com/vfarcic/dot-ai-cli/tree/main/docs/',
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
      '@docusaurus/plugin-content-docs',
      {
        id: 'ui',
        path: 'docs/ui',
        routeBasePath: 'docs/ui',
        sidebarPath: './sidebars/ui.ts',
        editUrl: 'https://github.com/vfarcic/dot-ai-ui/tree/main/docs/',
      },
    ],
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'stack',
        path: 'docs/stack',
        routeBasePath: 'docs/stack',
        sidebarPath: './sidebars/stack.ts',
        editUrl: 'https://github.com/vfarcic/dot-ai-stack/tree/main/docs/',
      },
    ],
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      {
        hashed: true,
        docsRouteBasePath: ['/docs/ai-engine', '/docs/mcp', '/docs/cli', '/docs/controller', '/docs/ui', '/docs/stack'],
        docsDir: ['docs/ai-engine', 'docs/mcp', 'docs/cli', 'docs/controller', 'docs/ui', 'docs/stack'],
        docsPluginIdForPreferredVersion: 'ai-engine',
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
          to: '/docs/stack',
          label: 'Getting Started',
          position: 'left',
        },
        {
          to: '/docs/ai-engine',
          label: 'AI Engine',
          position: 'left',
        },
        {
          to: '/docs/mcp',
          label: 'MCP',
          position: 'left',
        },
        {
          to: '/docs/cli',
          label: 'CLI',
          position: 'left',
        },
        {
          to: '/docs/controller',
          label: 'Controller',
          position: 'left',
        },
        {
          to: '/docs/ui',
          label: 'Web UI',
          position: 'left',
        },
        {
          type: 'dropdown',
          label: 'GitHub',
          position: 'right',
          items: [
            {
              href: 'https://github.com/vfarcic/dot-ai-stack',
              label: 'Stack',
            },
            {
              href: 'https://github.com/vfarcic/dot-ai',
              label: 'AI Engine / MCP',
            },
            {
              href: 'https://github.com/vfarcic/dot-ai-cli',
              label: 'CLI',
            },
            {
              href: 'https://github.com/vfarcic/dot-ai-controller',
              label: 'Controller',
            },
            {
              href: 'https://github.com/vfarcic/dot-ai-ui',
              label: 'Web UI',
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
              label: 'Getting Started',
              to: '/docs/stack',
            },
            {
              label: 'AI Engine',
              to: '/docs/ai-engine',
            },
            {
              label: 'MCP',
              to: '/docs/mcp',
            },
            {
              label: 'CLI',
              to: '/docs/cli',
            },
            {
              label: 'Controller',
              to: '/docs/controller',
            },
            {
              label: 'Web UI',
              to: '/docs/ui',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'AI Engine / MCP Discussions',
              href: 'https://github.com/vfarcic/dot-ai/discussions',
            },
            {
              label: 'CLI Discussions',
              href: 'https://github.com/vfarcic/dot-ai-cli/discussions',
            },
            {
              label: 'Controller Discussions',
              href: 'https://github.com/vfarcic/dot-ai-controller/discussions',
            },
            {
              label: 'Web UI Discussions',
              href: 'https://github.com/vfarcic/dot-ai-ui/discussions',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Stack GitHub',
              href: 'https://github.com/vfarcic/dot-ai-stack',
            },
            {
              label: 'AI Engine / MCP GitHub',
              href: 'https://github.com/vfarcic/dot-ai',
            },
            {
              label: 'CLI GitHub',
              href: 'https://github.com/vfarcic/dot-ai-cli',
            },
            {
              label: 'Controller GitHub',
              href: 'https://github.com/vfarcic/dot-ai-controller',
            },
            {
              label: 'Web UI GitHub',
              href: 'https://github.com/vfarcic/dot-ai-ui',
            },
            {
              label: 'llms.txt',
              href: '/llms.txt',
            },
            {
              label: 'llms-full.txt',
              href: '/llms-full.txt',
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
