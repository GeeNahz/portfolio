defmodule PortfolioWeb.HomeLiveTest do
  # Not async: section copy upserts on a unique key deadlock across sandboxes.
  use PortfolioWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Portfolio.ContentFixtures

  describe "with content" do
    setup do
      profile = profile_fixture()
      all_section_copies_fixture()
      stat = hero_stat_fixture()
      link = social_link_fixture()
      interface = stack_layer_fixture()

      phoenix =
        stack_layer_fixture(
          label: "Next: Phoenix",
          heading: "The next layer.",
          featured: true,
          highlights: ["LiveView."]
        )

      project = project_fixture(url: "https://example.com")
      principle = principle_fixture()
      topic = learning_topic_fixture()
      credential = credential_fixture()

      %{
        profile: profile,
        stat: stat,
        link: link,
        interface: interface,
        phoenix: phoenix,
        project: project,
        principle: principle,
        topic: topic,
        credential: credential
      }
    end

    test "renders every section", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/")

      for id <-
            ~w(site-nav theme-switch top hero-stats stack systems approach elixir credentials contact) do
        assert has_element?(lv, "##{id}"), "expected ##{id} to render"
      end
    end

    test "renders each piece of content", %{conn: conn} = ctx do
      {:ok, lv, _html} = live(conn, ~p"/")

      assert has_element?(lv, "#hero-stat-#{ctx.stat.id}")
      assert has_element?(lv, "#project-#{ctx.project.id} a[href='https://example.com']")
      assert has_element?(lv, "#principle-#{ctx.principle.id}")
      assert has_element?(lv, "#topic-#{ctx.topic.id}")
      assert has_element?(lv, "#credential-#{ctx.credential.id}")
      assert has_element?(lv, "#contact-link-#{ctx.link.id}")
      assert has_element?(lv, "#hero-cta[href='mailto:ada@example.com']")
      assert has_element?(lv, "#learning-link[href='https://example.com/notes']")
      assert has_element?(lv, "#site-nav a[href='https://github.com/example']")
    end

    test "shows the first stack layer and switches layers on click", %{conn: conn} = ctx do
      {:ok, lv, _html} = live(conn, ~p"/")

      assert has_element?(lv, "#layer-panel-#{ctx.interface.id}")
      assert has_element?(lv, "#layer-tab-#{ctx.interface.id}[aria-pressed='true']")
      assert has_element?(lv, "#layer-panel-#{ctx.interface.id} strong", "40%")

      lv |> element("#layer-tab-#{ctx.phoenix.id}") |> render_click()

      assert has_element?(lv, "#layer-panel-#{ctx.phoenix.id}")
      refute has_element?(lv, "#layer-panel-#{ctx.interface.id}")
      assert has_element?(lv, "#layer-tab-#{ctx.phoenix.id}[aria-pressed='true']")
    end

    test "ignores unknown layer ids", %{conn: conn} = ctx do
      {:ok, lv, _html} = live(conn, ~p"/")

      render_hook(lv, "select_layer", %{"id" => Ecto.UUID.generate()})

      assert has_element?(lv, "#layer-panel-#{ctx.interface.id}")
    end

    test "hides links that are switched off", %{conn: conn} = ctx do
      Portfolio.Content.update(ctx.link, %{show_in_nav: false, show_in_contact: false})

      {:ok, lv, _html} = live(conn, ~p"/")

      refute has_element?(lv, "#site-nav a[href='https://github.com/example']")
      refute has_element?(lv, "#contact-link-#{ctx.link.id}")
    end
  end

  test "renders without any content", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/")

    assert has_element?(lv, "#top")
    assert has_element?(lv, "#contact")
  end
end
