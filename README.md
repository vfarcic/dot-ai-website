# dot-ai Website

Documentation portal for the DevOps AI Toolkit, served at [devopstoolkit.ai](https://devopstoolkit.ai). Built with [Docusaurus](https://docusaurus.io/) and hosted on [Netlify](https://www.netlify.com/).

## Local Development

```bash
npm ci
./scripts/fetch-docs.sh   # pull docs from the source repositories
npm start
```

## Build

```bash
npm run build
```

Generates the static site into `build/`.

## Deployment

Deployments run in GitHub Actions, not on Netlify's build service:

- **Production**: `.github/workflows/release.yml` builds the site and runs `netlify deploy --prod --no-build` on every push to `main`, on `repository_dispatch` events from the upstream repositories (`upstream-release`, `docs-update`), and on manual dispatch.
- **Previews**: `.github/workflows/pr.yml` deploys each pull request to `https://pr-<number>--devopstoolkit-ai.netlify.app`.

Response headers (such as serving `.md` files as `text/plain`) are configured in `netlify.toml`. The Netlify CLI is provided by Devbox (`devbox run -- netlify ...`). The workflows need the `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` repository secrets.
