# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Phoenix 1.8 application scaffold (`mix phx.new portfolio --binary-id`) with Ecto/Postgres, LiveView, Tailwind v4 and esbuild.
- Public portfolio page (`PortfolioWeb.HomeLive` at `/`) built from the design: hero with stats strip, stack explorer, systems ledger, approach, currently-learning (Elixir) section, credentials strip and contact footer.
- Stack explorer tabs switch layers via the LiveView `select_layer` event, with `aria-pressed` buttons and a violet dashed style for featured layers.
- Portfolio design tokens (ink, paper, surface, accent, violet) as Tailwind v4 theme colours with light and dark values, plus the `.lnk`, `.btn-brut`, `.ledger-row` and `.layer-tab` hover styles.
- Self-hosted Bricolage Grotesque (variable 400–800) and IBM Plex Mono (400, 500) fonts in `priv/static/fonts`, preloaded from the root layout.
- Light / Dark / System theme switch in the site nav and admin top bar, driven by the root layout's `phx:set-theme` script.
- `Portfolio.Content` context: an ordered-collection API (`list`, `create`, `update`, `delete`, `move`), a singleton profile and per-section copy.
- UUID-keyed content tables, one migration per group: `profiles` + `hero_stats`, `social_links`, `stack_layers`, `projects`, `principles`, `learning_topics`, `credentials`, `section_copies`.
- `**double asterisk**` emphasis in content text renders as `<strong>`, with the text HTML-escaped first.
- Link fields accept only `http(s)`, `mailto:` and `#anchor` URLs.
- Idempotent `priv/repo/seeds.exs` containing all the design's content; re-running never overwrites edits made in the admin.
- Management portal at `/admin`: dashboard of all content areas with counts, profile form, section copy editor and create / edit / reorder / delete for hero stats, social links, stack layers, projects, approach habits, learning topics and credentials.
- Email + password and magic-link authentication from `phx.gen.auth` (LiveView) with UUID user ids.
- `mix portfolio.create_admin EMAIL PASSWORD` creates a confirmed admin account.
- Dev/test database settings read `DB_USER`, `DB_PASS`, `DB_HOST`, `DB_PORT`, `DB_NAME` and `DB_TEST_NAME`, defaulting to the previous `postgres`/`postgres` values; a local `.env` is loaded automatically in dev/test.
- `.env.example` documenting every environment variable the project reads.
- GitHub Actions CI (`.github/workflows/ci.yml`) running `mix precommit` against Postgres 18 on every push and on PRs into `master`/`staging`, plus unused-lock, formatting and clean-tree checks.
- `.tool-versions` pinning Erlang 29.0 and Elixir 1.19.5 for asdf and CI.
- README covering setup, `.env` configuration, creating the admin account, how each admin area maps to the public page, the precommit gate and the branch flow.

### Changed
- Core components (`button`, `input`, `flash`, `header`, `table`, `list`) restyled with the portfolio tokens: 2px ink borders, square corners, mono labels; `button` gains a `danger` variant.
- `Layouts.app` is now the admin shell (top bar + section navigation); new `Layouts.public` wraps the portfolio page.
- Log in, confirmation and account settings pages restyled to match the portfolio.
- Users land on `/admin` after logging in.
- `Portfolio.Repo` migrations default to `:binary_id` primary and foreign keys.

### Removed
- Public registration (`/users/register`); the admin account is created with the mix task only.
- Default Phoenix landing page (`PageController`).
