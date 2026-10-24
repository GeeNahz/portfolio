defmodule PortfolioWeb.Admin.CollectionLiveTest do
  use PortfolioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Portfolio.ContentFixtures

  alias Portfolio.Content
  alias Portfolio.Content.{Project, StackLayer}

  setup :register_and_log_in_user

  @project %{
    name: "New app",
    years: "2026",
    category: "SaaS",
    summary: "Built it.",
    outcome: "Shipped."
  }

  test "lists items in order with an empty state", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/admin/projects")
    assert has_element?(lv, "#items-empty")

    first = project_fixture(name: "First")
    second = project_fixture(name: "Second")

    {:ok, lv, _html} = live(conn, ~p"/admin/projects")

    assert has_element?(lv, "#items-#{first.id}", "First")
    assert has_element?(lv, "#items-#{second.id}", "Second")
    assert has_element?(lv, "#move-up-#{first.id}[disabled]")
    assert has_element?(lv, "#move-down-#{second.id}[disabled]")
  end

  test "creates an item", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/admin/projects/new")

    assert {:ok, index, _html} =
             lv
             |> form("#item-form", item: @project)
             |> render_submit()
             |> follow_redirect(conn, ~p"/admin/projects")

    assert [%Project{name: "New app"} = project] = Content.list(Project)
    assert has_element?(index, "#items-#{project.id}")
  end

  test "validates on change and on submit", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/admin/projects/new")

    lv |> form("#item-form", item: %{name: ""}) |> render_change()
    assert has_element?(lv, "#item-form", "can't be blank")

    lv |> form("#item-form", item: Map.put(@project, :url, "not a url")) |> render_submit()
    assert has_element?(lv, "#item-form", "must be an http(s), mailto: or #anchor link")
    assert Content.list(Project) == []
  end

  test "edits an item", %{conn: conn} do
    project = project_fixture()
    {:ok, lv, _html} = live(conn, ~p"/admin/projects/#{project.id}/edit")

    {:ok, _index, _html} =
      lv
      |> form("#item-form", item: %{outcome: "Live in 70 courts"})
      |> render_submit()
      |> follow_redirect(conn, ~p"/admin/projects")

    assert Content.get!(Project, project.id).outcome == "Live in 70 courts"
  end

  test "reorders items", %{conn: conn} do
    first = project_fixture(name: "First")
    second = project_fixture(name: "Second")
    {:ok, lv, _html} = live(conn, ~p"/admin/projects")

    lv |> element("#move-up-#{second.id}") |> render_click()

    assert Enum.map(Content.list(Project), & &1.id) == [second.id, first.id]
    assert has_element?(lv, "#move-up-#{second.id}[disabled]")
  end

  test "deletes an item", %{conn: conn} do
    project = project_fixture()
    {:ok, lv, _html} = live(conn, ~p"/admin/projects")

    lv |> element("#delete-#{project.id}") |> render_click()

    assert Content.list(Project) == []
    refute has_element?(lv, "#items-#{project.id}")
  end

  test "edits highlights one per line", %{conn: conn} do
    layer = stack_layer_fixture(highlights: ["one", "two"])
    {:ok, lv, _html} = live(conn, ~p"/admin/stack-layers/#{layer.id}/edit")

    assert lv |> element("#item-form textarea[name='item[highlights]']") |> render() =~
             "one\ntwo"

    lv
    |> form("#item-form", item: %{highlights: "first\r\n\r\n  second  \nthird"})
    |> render_submit()

    assert Content.get!(StackLayer, layer.id).highlights == ["first", "second", "third"]
  end

  test "edits a social link's visibility toggles", %{conn: conn} do
    link = social_link_fixture(show_in_nav: true)
    {:ok, lv, _html} = live(conn, ~p"/admin/social-links/#{link.id}/edit")

    lv |> form("#item-form", item: %{show_in_nav: "false"}) |> render_submit()

    refute Content.get!(Portfolio.Content.SocialLink, link.id).show_in_nav
  end
end
