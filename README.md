# Portfolio

Godswill Nasara's portfolio site: a Phoenix 1.8 LiveView app whose public page
content lives in Postgres and is edited from an authenticated management portal.

- **Public site** (`/`): hero, stack explorer, systems ledger, approach,
  currently-learning section, credentials and contact, with a light, dark or
  system theme.
- **Management portal** (`/admin`): edit the profile, section copy, and
  every content list (hero stats, social links, stack layers, projects,
  approach habits, learning topics, credentials). Lists can be reordered.

## Requirements

- Erlang/OTP and Elixir as pinned in `.tool-versions` (works with asdf).
- PostgreSQL. Dev/test default to `postgres`/`postgres` on `localhost:5432`.

## Setup

```sh
cp .env.example .env   # adjust DB_* if your Postgres differs
mix setup              # deps, database, migrations, seeds, assets
mix portfolio.create_admin you@example.com "a password of 12+ characters"
mix phx.server
```

Visit [`localhost:4000`](http://localhost:4000) for the site and
[`localhost:4000/admin`](http://localhost:4000/admin) to sign in.

Public registration is disabled. `mix portfolio.create_admin` is the only way to
create an account.

## Configuration

Every environment variable the app reads is listed in `.env.example`. In dev
and test, a local `.env` is loaded automatically (see `config/config.exs`), and
variables set in your shell take precedence. Production reads real environment
variables in `config/runtime.exs`.

## Content

`priv/repo/seeds.exs` seeds the content from the original design. It is safe to
re-run, because it only fills empty tables and missing sections. After that, all
content is edited in the admin.

In text fields, `**double asterisks**` render as **bold** on the public page.
Text is HTML-escaped, so markup typed into the admin is shown as plain text.

| Admin area | Public section |
|---|---|
| Profile | Nav name/role, hero headline/intro/button/badge, Elixir section link, contact email and footer |
| Section copy | The `// eyebrow`, heading and intro of the stack, systems, approach, Elixir and contact sections |
| Hero stats | Strip under the hero |
| Social links | Nav (`Show in nav`) and contact links (`Show in contact`) |
| Stack layers | Stack explorer tabs; `Featured` gives the violet "next layer" style |
| Projects | Systems ledger rows, numbered in list order |
| Approach | "How I think" habits |
| Learning topics | Elixir "currently learning" list |
| Credentials | Strip above contact |

## Development

```sh
mix precommit   # compile --warnings-as-errors, deps.unlock --unused, format, test
```

CI (`.github/workflows/ci.yml`) runs the same gate on every push and on pull
requests into `master` and `staging`.

### Branches

- `master` is the default and production branch.
- Work happens on `staging` and is merged into `master` by pull request.
- Every change is recorded in `CHANGELOG.md`.

## Deployment

Not set up yet. It will follow the same Docker/VPS setup as the keepsakes
project.
