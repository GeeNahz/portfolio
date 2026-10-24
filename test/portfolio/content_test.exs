defmodule Portfolio.ContentTest do
  # Not async: section copy upserts on a unique key deadlock across sandboxes.
  use Portfolio.DataCase, async: false

  import Portfolio.ContentFixtures

  alias Portfolio.Content
  alias Portfolio.Content.{HeroStat, Profile, Project, SectionCopy, SocialLink, StackLayer}

  describe "ordered collections" do
    test "create/2 appends to the end and list/1 returns display order" do
      first = project_fixture(name: "First")
      second = project_fixture(name: "Second")
      third = project_fixture(name: "Third")

      assert [first.position, second.position, third.position] == [0, 1, 2]
      assert Enum.map(Content.list(Project), & &1.name) == ["First", "Second", "Third"]
    end

    test "ids are UUIDs" do
      project = project_fixture()
      assert {:ok, _} = Ecto.UUID.cast(project.id)
    end

    test "create/2 validates required fields" do
      assert {:error, changeset} = Content.create(Project, %{})
      assert %{name: ["can't be blank"], outcome: ["can't be blank"]} = errors_on(changeset)
    end

    test "create/2 ignores a submitted position" do
      project_fixture()
      {:ok, project} = Content.create(Project, Map.put(valid_project(), :position, 99))
      assert project.position == 1
    end

    test "update/2 changes fields" do
      project = project_fixture()
      assert {:ok, %Project{name: "Renamed"}} = Content.update(project, %{name: "Renamed"})
    end

    test "delete/1 removes the row" do
      project = project_fixture()
      assert {:ok, _} = Content.delete(project)
      assert Content.list(Project) == []
    end

    test "move/2 swaps a row with its neighbour" do
      a = hero_stat_fixture(label: "a")
      b = hero_stat_fixture(label: "b")
      c = hero_stat_fixture(label: "c")

      assert {:ok, :moved} = Content.move(c, :up)
      assert labels(HeroStat) == ["a", "c", "b"]

      assert {:ok, :moved} = Content.move(a, :down)
      assert labels(HeroStat) == ["c", "a", "b"]

      assert {:ok, :unchanged} = Content.move(Content.get!(HeroStat, b.id), :down)
      assert {:ok, :unchanged} = Content.move(Content.get!(HeroStat, c.id), :up)
      assert labels(HeroStat) == ["c", "a", "b"]
    end

    test "count/1 counts rows" do
      assert Content.count(HeroStat) == 0
      hero_stat_fixture()
      assert Content.count(HeroStat) == 1
    end

    test "the generic API rejects schemas that are not collections" do
      assert_raise FunctionClauseError, fn -> Content.list(Profile) end
    end
  end

  describe "validations" do
    test "links accept http(s), mailto: and anchors only" do
      for url <- ["https://example.com", "http://example.com/x", "mailto:a@b.co", "#elixir"] do
        assert {:ok, _} = Content.create(SocialLink, social_link_attrs(url))
      end

      for url <- ["javascript:alert(1)", "example.com", "#", "ftp://example.com"] do
        assert {:error, changeset} = Content.create(SocialLink, social_link_attrs(url))
        assert %{url: [_]} = errors_on(changeset)
      end
    end

    test "stack layer highlights are trimmed and blank lines dropped" do
      layer = stack_layer_fixture(highlights: ["  one ", "", "two", "   "])
      assert layer.highlights == ["one", "two"]
    end
  end

  describe "profile" do
    test "get_profile/0 returns an unsaved profile when none exists" do
      assert %Profile{id: nil} = Content.get_profile()
    end

    test "save_profile/2 inserts once, then updates the same row" do
      profile = profile_fixture()
      assert {:ok, updated} = Content.save_profile(Content.get_profile(), %{name: "New"})
      assert updated.id == profile.id
      assert Repo.aggregate(Profile, :count) == 1
    end

    test "save_profile/2 validates email" do
      assert {:error, changeset} =
               Content.save_profile(%Profile{}, %{
                 name: "x",
                 role: "x",
                 headline: "x",
                 intro: "x",
                 email: "nope",
                 location: "x",
                 cta_label: "x"
               })

      assert %{email: ["must be a valid email"]} = errors_on(changeset)
    end
  end

  describe "section copy" do
    test "upsert_section_copy/1 creates and then replaces by key" do
      section_copy_fixture("systems", %{heading: "Old"})
      section_copy_fixture("systems", %{heading: "New"})

      assert %{"systems" => %SectionCopy{heading: "New"}} = Content.section_copies()
      assert Repo.aggregate(SectionCopy, :count) == 1
    end

    test "upsert_section_copy/1 rejects unknown keys" do
      assert {:error, changeset} =
               Content.upsert_section_copy(%{key: "nope", eyebrow: "x", heading: "y"})

      assert %{key: ["is invalid"]} = errors_on(changeset)
    end

    test "list_section_copies/0 returns page order" do
      for key <- Enum.reverse(SectionCopy.keys()), do: section_copy_fixture(key)
      assert Enum.map(Content.list_section_copies(), & &1.key) == SectionCopy.keys()
    end

    test "update_section_copy/2 never changes the key" do
      copy = section_copy_fixture("stack")
      assert {:ok, updated} = Content.update_section_copy(copy, %{key: "contact", heading: "H"})
      assert updated.key == "stack"
      assert updated.heading == "H"
    end
  end

  test "home_page/0 loads every section's content" do
    profile_fixture()
    stack_layer_fixture()

    page = Content.home_page()

    assert page.profile.name == "Ada Lovelace"
    assert [%StackLayer{}] = page.stack_layers

    for key <- ~w(hero_stats social_links projects principles learning_topics credentials)a do
      assert page[key] == []
    end
  end

  defp labels(schema), do: schema |> Content.list() |> Enum.map(& &1.label)

  defp valid_project do
    %{name: "P", years: "2024", category: "C", summary: "S", outcome: "O"}
  end

  defp social_link_attrs(url), do: %{label: "L", url: url, display_text: "D"}
end
