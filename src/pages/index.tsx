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
          <div className="col col--6">
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
          <div className="col col--6">
            <Link to="/docs/ai-engine" className={styles.gettingStartedLink}>
              <div className={clsx('card', styles.gettingStartedCard)}>
                <div className={styles.gettingStartedLogoContainer}>
                  <img
                    src="/img/logo-mcp.jpeg"
                    alt="AI Engine"
                    className={styles.gettingStartedLogo}
                  />
                </div>
                <div className={styles.gettingStartedTextContainer}>
                  <div className={styles.gettingStartedText}>
                    <Heading as="h3">AI Engine</Heading>
                    <p>
                      The core AI engine powering Kubernetes operations — tools,
                      deployment, configuration, and organizational data management.
                    </p>
                  </div>
                  <span className="button button--primary">
                    View Docs →
                  </span>
                </div>
              </div>
            </Link>
          </div>
        </div>
        <div className="row">
          <div className={clsx('col col--3')}>
            <Link to="/docs/mcp" className={styles.projectLink}>
              <div className={clsx('card padding--lg', styles.projectCard)}>
                <Heading as="h3">MCP</Heading>
                <p>
                  Connect to the AI Engine via the Model Context Protocol from any MCP client.
                </p>
                <span className="button button--primary">
                  View Docs
                </span>
              </div>
            </Link>
          </div>
          <div className={clsx('col col--3')}>
            <Link to="/docs/cli" className={styles.projectLink}>
              <div className={clsx('card padding--lg', styles.projectCard)}>
                <Heading as="h3">CLI</Heading>
                <p>
                  Command-line interface for direct interaction with the AI Engine from your terminal.
                </p>
                <span className="button button--primary">
                  View Docs
                </span>
              </div>
            </Link>
          </div>
          <div className={clsx('col col--3')}>
            <Link to="/docs/controller" className={styles.projectLink}>
              <div className={clsx('card padding--lg', styles.projectCard)}>
                <Heading as="h3">Controller</Heading>
                <p>
                  Kubernetes controller for resource tracking and event-driven operations.
                </p>
                <span className="button button--primary">
                  View Docs
                </span>
              </div>
            </Link>
          </div>
          <div className={clsx('col col--3')}>
            <Link to="/docs/ui" className={styles.projectLink}>
              <div className={clsx('card padding--lg', styles.projectCard)}>
                <Heading as="h3">Web UI</Heading>
                <p>
                  Web-based interface for interacting with dot-ai through a visual dashboard.
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
