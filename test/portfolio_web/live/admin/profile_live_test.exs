defmodule PortfolioWeb.Admin.ProfileLiveTest do
  use PortfolioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Portfolio.ContentFixtures

  alias Portfolio.Content

  setup :register_and_log_in_user

  @valid %{
    name: "Grace Hopper",
    role: "Engineer",
    headline: "Engineer",
    intro: "Compilers.",
    email: "grace@example.com",
    location: "Arlington",
    cta_label: "Email me"
  }

  test "creates the profile on first save", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/admin/profile")

    lv |> form("#profile-form", profile: @valid) |> render_submit()

    assert Content.get_profile().name == "Grace Hopper"
  end

  test "updates the existing profile", %{conn: conn} do
    profile = profile_fixture()
    {:ok, lv, _html} = live(conn, ~p"/admin/profile")

    lv |> form("#profile-form", profile: %{name: "Renamed"}) |> render_submit()

    assert %{id: id, name: "Renamed"} = Content.get_profile()
    assert id == profile.id
  end

  test "shows validation errors", %{conn: conn} do
    profile_fixture()
    {:ok, lv, _html} = live(conn, ~p"/admin/profile")

    lv |> form("#profile-form", profile: %{email: "nope", name: ""}) |> render_change()

    assert has_element?(lv, "#profile-form", "must be a valid email")
    assert has_element?(lv, "#profile-form", "can't be blank")
  end
end
