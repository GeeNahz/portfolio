defmodule PortfolioWeb.Admin.DashboardLiveTest do
  use PortfolioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Portfolio.ContentFixtures

  setup :register_and_log_in_user

  test "links to every content area", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/admin")

    assert has_element?(lv, "#area-profile[href='/admin/profile']")
    assert has_element?(lv, "#area-sections[href='/admin/sections']")

    for collection <- PortfolioWeb.Admin.Collections.all() do
      assert has_element?(lv, "#area-#{collection.slug}[href='/admin/#{collection.slug}']")
    end
  end

  test "shows counts and prompts for a missing profile", %{conn: conn} do
    project_fixture()
    project_fixture()

    {:ok, lv, _html} = live(conn, ~p"/admin")

    assert has_element?(lv, "#area-projects", "2 items")
    assert has_element?(lv, "#profile-missing")
  end

  test "hides the profile prompt once a profile exists", %{conn: conn} do
    profile_fixture()

    {:ok, lv, _html} = live(conn, ~p"/admin")

    refute has_element?(lv, "#profile-missing")
  end
end
