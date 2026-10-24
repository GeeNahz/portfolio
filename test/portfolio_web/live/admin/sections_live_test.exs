defmodule PortfolioWeb.Admin.SectionsLiveTest do
  # Not async: section copy upserts on a unique key deadlock across sandboxes.
  use PortfolioWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Portfolio.ContentFixtures

  alias Portfolio.Content

  setup :register_and_log_in_user

  test "shows a hint when there is no section copy", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/admin/sections")
    assert has_element?(lv, "#sections-empty")
  end

  test "edits one section's copy", %{conn: conn} do
    all_section_copies_fixture()
    {:ok, lv, _html} = live(conn, ~p"/admin/sections")

    for key <- Portfolio.Content.SectionCopy.keys() do
      assert has_element?(lv, "#section-form-#{key}")
    end

    lv
    |> form("#section-form-systems", section: %{heading: "Eight products."})
    |> render_submit()

    assert %{heading: "Eight products."} = Content.section_copies()["systems"]
    assert %{heading: "stack heading"} = Content.section_copies()["stack"]
  end

  test "rejects a blank heading", %{conn: conn} do
    all_section_copies_fixture()
    {:ok, lv, _html} = live(conn, ~p"/admin/sections")

    lv |> form("#section-form-contact", section: %{heading: ""}) |> render_submit()

    assert has_element?(lv, "#section-form-contact", "can't be blank")
    assert %{heading: "contact heading"} = Content.section_copies()["contact"]
  end
end
