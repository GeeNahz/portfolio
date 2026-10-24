# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Seeds the portfolio content shown in the original design. It is safe to
# re-run: the profile and each collection are only seeded while empty, and
# section copy is only inserted for keys that don't exist yet, so edits made
# in the admin portal are never overwritten.
#
# Text wrapped in **double asterisks** renders bold on the public page.

alias Portfolio.{Content, Repo}

alias Portfolio.Content.{
  Credential,
  HeroStat,
  LearningTopic,
  Principle,
  Project,
  SectionCopy,
  SocialLink,
  StackLayer
}

seed_collection = fn schema, rows ->
  if Content.count(schema) == 0 do
    Enum.each(rows, fn attrs -> {:ok, _} = Content.create(schema, attrs) end)
  end
end

## Profile

if Content.get_profile().id == nil do
  {:ok, _} =
    Content.save_profile(Content.get_profile(), %{
      name: "Godswill Nasara",
      role: "Software engineer",
      headline: "Software engineer",
      intro:
        "I design, build and ship whole systems: the interface people touch, the services behind it, the data underneath and the pipeline that gets it live. Five years in, my software runs in courts, payroll offices, gyms and marketplaces.",
      email: "godswilldev@gmail.com",
      location: "Abuja, Nigeria",
      learning_badge: "now learning: Elixir + Phoenix",
      cta_label: "Say hello",
      learning_link_label: "[LINK TO YOUR ELIXIR / PHOENIX PROJECTS OR NOTES]",
      learning_link_url: "#contact"
    })
end

## Hero stats

seed_collection.(HeroStat, [
  %{label: "7 products shipped"},
  %{label: "62 courts"},
  %{label: "700,000+ records served"},
  %{label: "5+ years"},
  %{label: "Abuja, NG"}
])

## Social links

seed_collection.(SocialLink, [
  %{
    label: "GitHub",
    url: "https://github.com/geenahz",
    display_text: "github.com/geenahz",
    show_in_nav: true,
    show_in_contact: true
  },
  %{
    label: "LinkedIn",
    url: "https://linkedin.com/in/godswill-nasara",
    display_text: "linkedin.com/in/godswill-nasara",
    show_in_nav: false,
    show_in_contact: true
  }
])

## Section copy

existing_keys = Repo.all(SectionCopy) |> MapSet.new(& &1.key)

[
  %{
    key: "stack",
    eyebrow: "follow a request through the stack",
    heading: "I don’t stop at the layer I was hired for.",
    intro: "Pick a layer. Every claim here comes from something I shipped."
  },
  %{
    key: "systems",
    eyebrow: "systems shipped",
    heading: "Seven products, seven different problems."
  },
  %{
    key: "approach",
    eyebrow: "how I think",
    heading: "Four habits that show up in every project."
  },
  %{
    key: "elixir",
    eyebrow: "currently learning",
    heading: "Elixir and Phoenix are my next layer.",
    intro:
      "I build systems people depend on, so I’m learning the platform that was designed around staying up. Still early. I’m learning in the open."
  },
  %{
    key: "contact",
    eyebrow: "let’s talk",
    heading: "Got something that has to work?"
  }
]
|> Enum.reject(&MapSet.member?(existing_keys, &1.key))
|> Enum.each(fn attrs -> {:ok, _} = Content.upsert_section_copy(attrs) end)

## Stack layers

seed_collection.(StackLayer, [
  %{
    label: "Interface",
    heading: "Interfaces that hold up under real use.",
    summary:
      "React, Next.js and strict TypeScript, designed around who is using it and what their connection is like.",
    highlights: [
      "Co-authored strict-mode conventions and a shared typed component library, cutting QA-reported runtime errors by an estimated **40%**.",
      "Built role-based rendering and dynamic routing so judges, clerks and legal assistants each get exactly what they need.",
      "Optimistic UI, skeleton loaders and lazy-loaded routes for field agents on poor networks.",
      "Lighthouse-led performance work: **23%** faster loads, then **70%** more membership renewals."
    ]
  },
  %{
    label: "Services",
    heading: "Services and APIs I design, not just consume.",
    summary:
      "Django, FastAPI and Node.js behind REST APIs, built with the client that will call them in mind.",
    highlights: [
      "Treated slow admin reporting as a structural problem and built automated dashboards on React Query and Django REST: report time down **80%**.",
      "Built typed API responses and admin tooling with filtering, pagination and bulk actions that replaced spreadsheet workflows."
    ]
  },
  %{
    label: "Data",
    heading: "Data models chosen for the problem.",
    summary:
      "PostgreSQL, MongoDB and Cloud Firestore, picked by assessing what the product needs to do, not by habit.",
    highlights: [
      "Chose MongoDB over a relational database for a fast-evolving onboarding schema, so the team iterated without costly migrations.",
      "Removed redundant field-validation calls and streamlined form architecture, improving batch data collation by **20%**."
    ]
  },
  %{
    label: "Delivery",
    heading: "I own the path to production.",
    summary:
      "GitHub Actions, Docker, Nginx and VPS deployments, run by the same person who wrote the code.",
    highlights: [
      "Owned CI/CD, code splitting and tree shaking, and shrank a production Docker image to about **4%** of its original size.",
      "When a Vercel deployment couldn’t sustain production traffic, I migrated it to a self-hosted VPS with Docker and Nginx, restoring stability.",
      "Set up developer accounts and deployed the mobile app early on a client project, so integration issues surfaced before they compounded."
    ]
  },
  %{
    label: "Trust",
    heading: "Security and privacy from the first commit.",
    summary:
      "XSS/CSRF prevention, secure token storage and session management, with NDPR/GDPR-aligned data handling.",
    highlights: [
      "Applied privacy-by-design (access-scoped UI, input sanitisation, secure data handling) on a platform where one data error can change a civil servant’s salary.",
      "Certified in General Data Privacy Awareness, T.A.A.S Cyber Solutions Ltd, March 2026."
    ]
  },
  %{
    label: "Next: Phoenix",
    heading: "The next layer: Elixir and Phoenix.",
    summary: "I’m learning the BEAM, Phoenix and LiveView to go deeper on how servers stay up.",
    featured: true,
    link_label: "See what I’m learning ↓",
    link_url: "#elixir",
    highlights: [
      "Supervised, lightweight processes and fault tolerance as a starting point.",
      "Real-time interfaces with state on the server, via LiveView."
    ]
  }
])

## Projects

seed_collection.(Project, [
  %{
    name: "JudicAI",
    years: "2024 – 26",
    category: "LegalTech · court management & e-filing",
    summary:
      "Role-based architecture, shared typed component library, CI/CD, Docker + Nginx deployments, reporting dashboards.",
    outcome: "Live in 62 courts, 124+ active users, 50% better workflow efficiency"
  },
  %{
    name: "IPPIS",
    years: "2024",
    category: "GovTech · payroll & personnel records",
    summary:
      "Custom validation architecture, low-connectivity multi-step flows, Vercel-to-VPS migration, privacy-by-design.",
    outcome: "700,000+ public servants’ records, 20% faster data collation"
  },
  %{
    name: "Aforlink",
    years: "2024 – 26",
    category: "Marketplace · admin portal",
    summary:
      "Led the build from early architecture to launch with backend, mobile, QA, product and design. Admin portal covers verification, moderation and complaints.",
    outcome: "Early mobile deployment cut timeline risk; portal built to grow without rework"
  },
  %{
    name: "CADEMit",
    years: "2022 – 23",
    category: "Assessment & onboarding platform",
    summary:
      "Full stack: Next.js, TypeScript, MongoDB. Candidate pipeline and recruiter dashboards with filtering, pagination and bulk actions.",
    outcome: "50+ candidates per cohort, 40% faster decisions, 35% less evaluation time"
  },
  %{
    name: "Jas Fitness Center",
    years: "2022 – 23",
    category: "Fitness · bookings & memberships",
    summary:
      "Client booking, class scheduling and membership management, with a Lighthouse-driven performance pass.",
    outcome: "Live and in daily use since delivery, 70% more renewals",
    url: "https://gym.jasfitnessng.com"
  },
  %{
    name: "Property Plug",
    years: "2021",
    category: "Real estate search",
    summary:
      "Map-based discovery and dynamic filtering, shaped by research showing seekers valued findability over aesthetics.",
    outcome: "Design handoff to production in 6 weeks"
  },
  %{
    name: "Eli and Lulu Cafe",
    years: "2021",
    category: "Restaurant management",
    summary: "Menu management, order tracking and table reservations in a responsive system.",
    outcome: "On schedule, zero critical post-launch bugs"
  }
])

## Approach

seed_collection.(Principle, [
  %{
    title: "Diagnose before I optimise.",
    body:
      "Poor retention turned out to be slow loads. Slow reports turned out to be structure, not data. I find the real cause first."
  },
  %{
    title: "Choose the tool on purpose.",
    body:
      "Custom validation hooks over a form library at 700,000+ records. MongoDB over relational for a moving schema. A VPS over Vercel when traffic demanded it. Each call came with a reason."
  },
  %{
    title: "Surface risk early.",
    body:
      "I deployed a mobile app on day one of a client project so environment problems showed up while they were cheap to fix."
  },
  %{
    title: "Make the whole team faster.",
    body:
      "Shared component libraries and conventions, Claude in our daily review and refactoring (about 25% faster sprints), 20+ students taught at NACOMES, 5 developers mentored through delivery."
  }
])

## Currently learning

seed_collection.(LearningTopic, [
  %{
    title: "Processes, not threads",
    body:
      "Lightweight, supervised processes on the BEAM. Fault tolerance is where the design starts."
  },
  %{
    title: "LiveView",
    body:
      "Real-time interfaces with state on the server: a very different answer to problems I usually solve with React Query and client state."
  },
  %{
    title: "Pipes and pattern matching",
    body: "Code that reads as small, explicit transformations."
  }
])

## Credentials

seed_collection.(Credential, [
  %{
    kind: "Education",
    body:
      "B.Eng Computer Engineering, Second Class Upper. Federal University of Technology, Minna, 2024."
  },
  %{
    kind: "Certification",
    body: "General Data Privacy Awareness (NDPR/GDPR-aligned), March 2026."
  },
  %{
    kind: "Teaching",
    body: "Trained 20+ engineering students in JavaScript and React at NACOMES, 2023 – 2024."
  },
  %{
    kind: "Tools",
    body: "Git, Jira, Notion, and Claude in my daily development, review and refactoring."
  }
])
