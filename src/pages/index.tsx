import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <img
          src="/img/logo.jpeg"
          alt="DevOps AI Toolkit Logo"
          className={styles.heroLogo}
        />
        <Heading as="h1" className="hero__title">
          {siteConfig.title}
        </Heading>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
      </div>
    </header>
  );
}

function ProjectsSection() {
  return (
    <section className={styles.projects}>
      <div className="container">
        <div className="row margin-bottom--md">
          <div className="col col--12">
            <Link to="/docs/stack" className={styles.gettingStartedLink}>
              <div className={clsx('card', styles.gettingStartedCard)}>
                <div className={styles.gettingStartedLogoContainer}>
                  <img
                    src="/img/logo-stack.jpeg"
                    alt="Getting Started"
                    className={styles.gettingStartedLogo}
                  />
                </div>
                <div className={styles.gettingStartedTextContainer}>
                  <div className={styles.gettingStartedText}>
                    <Heading as="h3">Getting Started</Heading>
                    <p>
                      Deploy the complete DevOps AI Toolkit stack with a single Helm command.
                      The fastest way to get up and running.
                    </p>
                  </div>
                  <span className="button button--primary">
                    Start Here →
                  </span>
                </div>
              </div>
            </Link>
          </div>
        </div>
        <div className="row">
          <div className={clsx('col col--4')}>
            <Link to="/docs/mcp" className={styles.projectLink}>
              <div className={clsx('card padding--lg', styles.projectCard)}>
                <div className={styles.projectLogoContainer}>
                  <img
                    src="/img/logo-mcp.jpeg"
                    alt="MCP Server"
                    className={styles.projectLogo}
                  />
                </div>
                <Heading as="h3">MCP Server</Heading>
                <p>
                  Model Context Protocol server that brings AI-powered capabilities
                  to your Kubernetes workflows through natural language interaction.
                </p>
                <span className="button button--primary">
                  View Docs
                </span>
              </div>
            </Link>
          </div>
          <div className={clsx('col col--4')}>
            <Link to="/docs/controller" className={styles.projectLink}>
              <div className={clsx('card padding--lg', styles.projectCard)}>
                <div className={styles.projectLogoContainer}>
                  <img
                    src="/img/logo-controller.jpeg"
                    alt="Controller"
                    className={styles.projectLogo}
                  />
                </div>
                <Heading as="h3">Controller</Heading>
                <p>
                  Kubernetes controller for resource tracking and event-driven
                  operations in your clusters.
                </p>
                <span className="button button--primary">
                  View Docs
                </span>
              </div>
            </Link>
          </div>
          <div className={clsx('col col--4')}>
            <Link to="/docs/ui" className={styles.projectLink}>
              <div className={clsx('card padding--lg', styles.projectCard)}>
                <div className={styles.projectLogoContainer}>
                  <img
                    src="/img/logo-ui.jpeg"
                    alt="Web UI"
                    className={styles.projectLogo}
                  />
                </div>
                <Heading as="h3">Web UI</Heading>
                <p>
                  Web-based user interface for interacting with dot-ai capabilities
                  through a visual dashboard.
                </p>
                <span className="button button--primary">
                  View Docs
                </span>
              </div>
            </Link>
          </div>
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  return (
    <Layout
      title="Home"
      description="AI-powered Kubernetes operations for DevOps teams.">
      <HomepageHeader />
      <main>
        <ProjectsSection />
      </main>
    </Layout>
  );
}
