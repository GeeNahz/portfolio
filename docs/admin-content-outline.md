# Admin content outline

Everything to enter in the management portal (`/admin`) so the public page
matches the original design.

> **Shortcut:** `mix run priv/repo/seeds.exs` enters all of this automatically
> and is safe to re-run. Use this outline for manual entry (e.g. on a fresh
> production database) or as a reference for what each field controls.

Enter items **in the order listed**. Lists display in that order, and ordinals such
as `01` and `02` are generated from it. You can reorder later with the ↑ / ↓ buttons.
`**text**` renders bold.

**Totals:**

| Area | Items |
|---|---|
| Profile | 1 |
| Section copy | 5 |
| Hero stats | 5 |
| Social links | 2 |
| Stack layers | 6, with 15 highlights |
| Projects | 7 |
| Approach habits | 4 |
| Learning topics | 3 |
| Credentials | 4 |

---

## 1. Profile — `/admin/profile` (1 record)

| Field | Value |
|---|---|
| Name | Godswill Nasara |
| Role | Software engineer *(shown lower-cased in the nav: "/ software engineer")* |
| Email | godswilldev@gmail.com *(hero button and contact button)* |
| Location | Abuja, Nigeria *(contact footer)* |
| Headline | Software engineer *(the giant hero heading; the orange square is added automatically)* |
| Intro | I design, build and ship whole systems: the interface people touch, the services behind it, the data underneath and the pipeline that gets it live. Five years in, my software runs in courts, payroll offices, gyms and marketplaces. |
| Email button label | Say hello *(the → is added automatically)* |
| Learning badge | now learning: Elixir + Phoenix *(rotated violet tag; leave blank to hide)* |
| Link label | [LINK TO YOUR ELIXIR / PHOENIX PROJECTS OR NOTES] *(placeholder from the design; replace with your real label)* |
| Link URL | #contact *(placeholder; replace with your notes/repo URL)* |

## 2. Section copy — `/admin/sections` (5 records, edit only)

The eyebrow is shown as `// eyebrow`. Section copy rows are created by the seeds,
not in the admin, so the seeds must run at least once.

| Section | Eyebrow | Heading | Intro |
|---|---|---|---|
| Stack explorer | follow a request through the stack | I don’t stop at the layer I was hired for. | Pick a layer. Every claim here comes from something I shipped. |
| Systems ledger | systems shipped | Seven products, seven different problems. | — |
| Approach | how I think | Four habits that show up in every project. | — |
| Currently learning | currently learning | Elixir and Phoenix are my next layer. | I build systems people depend on, so I’m learning the platform that was designed around staying up. Still early. I’m learning in the open. |
| Contact | let’s talk | Got something that has to work? | — |

## 3. Hero stats — `/admin/hero-stats` (5)

1. 7 products shipped
2. 62 courts
3. 700,000+ records served
4. 5+ years
5. Abuja, NG

## 4. Social links — `/admin/social-links` (2)

| # | Label | URL | Display text | Show in nav | Show in contact |
|---|---|---|---|---|---|
| 1 | GitHub | https://github.com/geenahz | github.com/geenahz | ✓ | ✓ |
| 2 | LinkedIn | https://linkedin.com/in/godswill-nasara | linkedin.com/in/godswill-nasara | — | ✓ |

## 5. Stack layers — `/admin/stack-layers` (6)

Highlights go **one per line** in the Highlights box. Tab numbers (01–06) are automatic.

### 01 · Interface
- **Heading:** Interfaces that hold up under real use.
- **Summary:** React, Next.js and strict TypeScript, designed around who is using it and what their connection is like.
- **Highlights:**
  1. Co-authored strict-mode conventions and a shared typed component library, cutting QA-reported runtime errors by an estimated \*\*40%\*\*.
  2. Built role-based rendering and dynamic routing so judges, clerks and legal assistants each get exactly what they need.
  3. Optimistic UI, skeleton loaders and lazy-loaded routes for field agents on poor networks.
  4. Lighthouse-led performance work: \*\*23%\*\* faster loads, then \*\*70%\*\* more membership renewals.

### 02 · Services
- **Heading:** Services and APIs I design, not just consume.
- **Summary:** Django, FastAPI and Node.js behind REST APIs, built with the client that will call them in mind.
- **Highlights:**
  1. Treated slow admin reporting as a structural problem and built automated dashboards on React Query and Django REST: report time down \*\*80%\*\*.
  2. Built typed API responses and admin tooling with filtering, pagination and bulk actions that replaced spreadsheet workflows.

### 03 · Data
- **Heading:** Data models chosen for the problem.
- **Summary:** PostgreSQL, MongoDB and Cloud Firestore, picked by assessing what the product needs to do, not by habit.
- **Highlights:**
  1. Chose MongoDB over a relational database for a fast-evolving onboarding schema, so the team iterated without costly migrations.
  2. Removed redundant field-validation calls and streamlined form architecture, improving batch data collation by \*\*20%\*\*.

### 04 · Delivery
- **Heading:** I own the path to production.
- **Summary:** GitHub Actions, Docker, Nginx and VPS deployments, run by the same person who wrote the code.
- **Highlights:**
  1. Owned CI/CD, code splitting and tree shaking, and shrank a production Docker image to about \*\*4%\*\* of its original size.
  2. When a Vercel deployment couldn’t sustain production traffic, I migrated it to a self-hosted VPS with Docker and Nginx, restoring stability.
  3. Set up developer accounts and deployed the mobile app early on a client project, so integration issues surfaced before they compounded.

### 05 · Trust
- **Heading:** Security and privacy from the first commit.
- **Summary:** XSS/CSRF prevention, secure token storage and session management, with NDPR/GDPR-aligned data handling.
- **Highlights:**
  1. Applied privacy-by-design (access-scoped UI, input sanitisation, secure data handling) on a platform where one data error can change a civil servant’s salary.
  2. Certified in General Data Privacy Awareness, T.A.A.S Cyber Solutions Ltd, March 2026.

### 06 · Next: Phoenix — tick **Featured**
- **Heading:** The next layer: Elixir and Phoenix.
- **Summary:** I’m learning the BEAM, Phoenix and LiveView to go deeper on how servers stay up.
- **Link label:** See what I’m learning ↓
- **Link URL:** #elixir
- **Highlights:**
  1. Supervised, lightweight processes and fault tolerance as a starting point.
  2. Real-time interfaces with state on the server, via LiveView.

## 6. Projects — `/admin/projects` (7)

| # | Name | Years | Category | What I built | Outcome | Live URL |
|---|---|---|---|---|---|---|
| 01 | JudicAI | 2024 – 26 | LegalTech · court management & e-filing | Role-based architecture, shared typed component library, CI/CD, Docker + Nginx deployments, reporting dashboards. | Live in 62 courts, 124+ active users, 50% better workflow efficiency | — |
| 02 | IPPIS | 2024 | GovTech · payroll & personnel records | Custom validation architecture, low-connectivity multi-step flows, Vercel-to-VPS migration, privacy-by-design. | 700,000+ public servants’ records, 20% faster data collation | — |
| 03 | Aforlink | 2024 – 26 | Marketplace · admin portal | Led the build from early architecture to launch with backend, mobile, QA, product and design. Admin portal covers verification, moderation and complaints. | Early mobile deployment cut timeline risk; portal built to grow without rework | — |
| 04 | CADEMit | 2022 – 23 | Assessment & onboarding platform | Full stack: Next.js, TypeScript, MongoDB. Candidate pipeline and recruiter dashboards with filtering, pagination and bulk actions. | 50+ candidates per cohort, 40% faster decisions, 35% less evaluation time | — |
| 05 | Jas Fitness Center | 2022 – 23 | Fitness · bookings & memberships | Client booking, class scheduling and membership management, with a Lighthouse-driven performance pass. | Live and in daily use since delivery, 70% more renewals | https://gym.jasfitnessng.com |
| 06 | Property Plug | 2021 | Real estate search | Map-based discovery and dynamic filtering, shaped by research showing seekers valued findability over aesthetics. | Design handoff to production in 6 weeks | — |
| 07 | Eli and Lulu Cafe | 2021 | Restaurant management | Menu management, order tracking and table reservations in a responsive system. | On schedule, zero critical post-launch bugs | — |

A project with a Live URL gets a linked name with ↗.

## 7. Approach — `/admin/approach` (4)

1. **Diagnose before I optimise.** Poor retention turned out to be slow loads. Slow reports turned out to be structure, not data. I find the real cause first.
2. **Choose the tool on purpose.** Custom validation hooks over a form library at 700,000+ records. MongoDB over relational for a moving schema. A VPS over Vercel when traffic demanded it. Each call came with a reason.
3. **Surface risk early.** I deployed a mobile app on day one of a client project so environment problems showed up while they were cheap to fix.
4. **Make the whole team faster.** Shared component libraries and conventions, Claude in our daily review and refactoring (about 25% faster sprints), 20+ students taught at NACOMES, 5 developers mentored through delivery.

## 8. Learning topics — `/admin/learning` (3)

1. **Processes, not threads.** Lightweight, supervised processes on the BEAM. Fault tolerance is where the design starts.
2. **LiveView.** Real-time interfaces with state on the server: a very different answer to problems I usually solve with React Query and client state.
3. **Pipes and pattern matching.** Code that reads as small, explicit transformations.

The two code samples beside this list are part of the design and not editable.
The pipeline sample uses your profile name.

## 9. Credentials — `/admin/credentials` (4)

| # | Kind | Body |
|---|---|---|
| 1 | Education | B.Eng Computer Engineering, Second Class Upper. Federal University of Technology, Minna, 2024. |
| 2 | Certification | General Data Privacy Awareness (NDPR/GDPR-aligned), March 2026. |
| 3 | Teaching | Trained 20+ engineering students in JavaScript and React at NACOMES, 2023 – 2024. |
| 4 | Tools | Git, Jira, Notion, and Claude in my daily development, review and refactoring. |

---

### Not editable (fixed in code)

- Nav anchors: Stack · Systems · Approach · Elixir · Contact.
- The theme switch, colours and fonts.
- The Elixir code samples.
- The footer year, which is always the current year.
