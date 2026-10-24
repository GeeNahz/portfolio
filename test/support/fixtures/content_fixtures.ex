defmodule Portfolio.ContentFixtures do
  @moduledoc """
  Test helpers for creating portfolio content.
  """
  alias Portfolio.Content

  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      Content.save_profile(
        Content.get_profile(),
        Enum.into(attrs, %{
          name: "Ada Lovelace",
          role: "Software engineer",
          headline: "Software engineer",
          intro: "I build analytical engines.",
          email: "ada@example.com",
          location: "London, UK",
          cta_label: "Say hello",
          learning_badge: "now learning: Elixir",
          learning_link_label: "My notes",
          learning_link_url: "https://example.com/notes"
        })
      )

    profile
  end

  def section_copy_fixture(key, attrs \\ %{}) do
    {:ok, copy} =
      Content.upsert_section_copy(
        Enum.into(attrs, %{key: key, eyebrow: "#{key} eyebrow", heading: "#{key} heading"})
      )

    copy
  end

  def all_section_copies_fixture do
    Enum.map(Portfolio.Content.SectionCopy.keys(), &section_copy_fixture/1)
  end

  def hero_stat_fixture(attrs \\ %{}),
    do: create(Content.HeroStat, attrs, %{label: "62 courts"})

  def social_link_fixture(attrs \\ %{}),
    do:
      create(Content.SocialLink, attrs, %{
        label: "GitHub",
        url: "https://github.com/example",
        display_text: "github.com/example",
        show_in_nav: true,
        show_in_contact: true
      })

  def stack_layer_fixture(attrs \\ %{}),
    do:
      create(Content.StackLayer, attrs, %{
        label: "Interface",
        heading: "Interfaces that hold up.",
        summary: "React and TypeScript.",
        highlights: ["Cut errors by **40%**.", "Role-based rendering."]
      })

  def project_fixture(attrs \\ %{}),
    do:
      create(Content.Project, attrs, %{
        name: "JudicAI",
        years: "2024 – 26",
        category: "LegalTech",
        summary: "Court management.",
        outcome: "Live in 62 courts"
      })

  def principle_fixture(attrs \\ %{}),
    do: create(Content.Principle, attrs, %{title: "Diagnose first.", body: "Find the cause."})

  def learning_topic_fixture(attrs \\ %{}),
    do: create(Content.LearningTopic, attrs, %{title: "LiveView", body: "State on the server."})

  def credential_fixture(attrs \\ %{}),
    do: create(Content.Credential, attrs, %{kind: "Education", body: "B.Eng, 2024."})

  defp create(schema, attrs, defaults) do
    {:ok, item} = Content.create(schema, Enum.into(attrs, defaults))
    item
  end
end
