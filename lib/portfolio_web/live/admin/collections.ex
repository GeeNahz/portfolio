defmodule PortfolioWeb.Admin.Collections do
  @moduledoc """
  Registry of the ordered content collections editable in the admin portal.

  Each entry drives `PortfolioWeb.Admin.CollectionLive`: the URL slug, the
  schema, labels, which fields the form shows and how list rows are titled.

  Field types are `<.input>` types, plus `"lines"`: a textarea where each
  line becomes one element of an array field.
  """
  alias Portfolio.Content

  @collections [
    %{
      slug: "hero-stats",
      schema: Content.HeroStat,
      title: "Hero stats",
      singular: "stat",
      section: "Hero",
      description: "Short facts in the strip under the hero, e.g. “62 courts”.",
      title_field: :label,
      subtitle_field: nil,
      fields: [
        %{name: :label, type: "text", label: "Label"}
      ]
    },
    %{
      slug: "social-links",
      schema: Content.SocialLink,
      title: "Social links",
      singular: "link",
      section: "Nav & contact",
      description: "Profiles linked from the nav bar and the contact section.",
      title_field: :label,
      subtitle_field: :display_text,
      fields: [
        %{name: :label, type: "text", label: "Label", help: "Shown in the nav, e.g. GitHub"},
        %{name: :url, type: "url", label: "URL"},
        %{
          name: :display_text,
          type: "text",
          label: "Display text",
          help: "Shown in the contact section, e.g. github.com/you"
        },
        %{name: :show_in_nav, type: "checkbox", label: "Show in nav"},
        %{name: :show_in_contact, type: "checkbox", label: "Show in contact section"}
      ]
    },
    %{
      slug: "stack-layers",
      schema: Content.StackLayer,
      title: "Stack layers",
      singular: "layer",
      section: "Stack explorer",
      description: "The tabs of the “follow a request through the stack” explorer.",
      title_field: :label,
      subtitle_field: :heading,
      fields: [
        %{name: :label, type: "text", label: "Tab label", help: "Numbered automatically"},
        %{name: :heading, type: "text", label: "Heading"},
        %{name: :summary, type: "textarea", label: "Summary"},
        %{
          name: :highlights,
          type: "lines",
          label: "Highlights",
          help: "One per line. Wrap text in **double asterisks** to make it bold."
        },
        %{
          name: :featured,
          type: "checkbox",
          label: "Featured (violet “next layer” style)"
        },
        %{name: :link_label, type: "text", label: "Link label (optional)"},
        %{
          name: :link_url,
          type: "text",
          label: "Link URL (optional)",
          help: "An http(s) URL or an anchor such as #elixir"
        }
      ]
    },
    %{
      slug: "projects",
      schema: Content.Project,
      title: "Projects",
      singular: "project",
      section: "Systems ledger",
      description: "Rows of the “systems shipped” ledger, numbered in this order.",
      title_field: :name,
      subtitle_field: :category,
      fields: [
        %{name: :name, type: "text", label: "Name"},
        %{name: :years, type: "text", label: "Years", help: "e.g. 2024 – 26"},
        %{name: :category, type: "text", label: "Category"},
        %{name: :summary, type: "textarea", label: "What I built"},
        %{name: :outcome, type: "textarea", label: "Outcome"},
        %{name: :url, type: "url", label: "Live URL (optional)"}
      ]
    },
    %{
      slug: "approach",
      schema: Content.Principle,
      title: "Approach",
      singular: "habit",
      section: "Approach",
      description: "The numbered habits in the “how I think” section.",
      title_field: :title,
      subtitle_field: nil,
      fields: [
        %{name: :title, type: "text", label: "Title"},
        %{name: :body, type: "textarea", label: "Body"}
      ]
    },
    %{
      slug: "learning",
      schema: Content.LearningTopic,
      title: "Learning topics",
      singular: "topic",
      section: "Currently learning",
      description: "Topics listed in the Elixir “currently learning” section.",
      title_field: :title,
      subtitle_field: nil,
      fields: [
        %{name: :title, type: "text", label: "Title"},
        %{name: :body, type: "textarea", label: "Body"}
      ]
    },
    %{
      slug: "credentials",
      schema: Content.Credential,
      title: "Credentials",
      singular: "credential",
      section: "Credentials strip",
      description: "Education, certification, teaching and tools above the contact section.",
      title_field: :kind,
      subtitle_field: :body,
      fields: [
        %{name: :kind, type: "text", label: "Kind", help: "e.g. Education"},
        %{name: :body, type: "textarea", label: "Body"}
      ]
    }
  ]

  @doc "All collections in admin navigation order."
  def all, do: @collections

  @doc "Fetches a collection by URL slug."
  def fetch(slug) do
    case Enum.find(@collections, &(&1.slug == slug)) do
      nil -> :error
      collection -> {:ok, collection}
    end
  end

  @doc """
  Converts submitted form params into changeset attrs: `"lines"` fields are
  split into lists.
  """
  def normalize_params(collection, params) do
    Enum.reduce(collection.fields, params, fn
      %{type: "lines", name: name}, acc ->
        key = Atom.to_string(name)

        case acc do
          %{^key => value} when is_binary(value) -> Map.put(acc, key, String.split(value, ~r/\R/))
          _ -> acc
        end

      _field, acc ->
        acc
    end)
  end
end
