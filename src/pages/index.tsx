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
        <div className="row">
          <div className={clsx('col col--6')}>
            <div className="card margin--md padding--lg">
              <Heading as="h3">MCP Server</Heading>
              <p>
                Model Context Protocol server that brings AI-powered capabilities
                to your Kubernetes workflows through natural language interaction.
              </p>
              <Link className="button button--primary" to="/docs/mcp/intro">
                View Docs
              </Link>
            </div>
          </div>
          <div className={clsx('col col--6')}>
            <div className="card margin--md padding--lg">
              <Heading as="h3">Controller</Heading>
              <p>
                Kubernetes controller for resource tracking and event-driven
                operations in your clusters.
              </p>
              <Link className="button button--primary" to="/docs/controller/intro">
                View Docs
              </Link>
            </div>
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
