defmodule PortfolioWeb.Admin.AccessTest do
  use PortfolioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @admin_paths ~w(/admin /admin/profile /admin/sections /admin/projects /admin/projects/new)

  test "signed-out visitors are sent to log in", %{conn: conn} do
    for path <- @admin_paths do
      assert {:error, {:redirect, %{to: "/users/log-in"}}} = live(conn, path)
    end
  end

  describe "signed in" do
    setup :register_and_log_in_user

    test "every admin page mounts", %{conn: conn} do
      for path <- @admin_paths do
        assert {:ok, _lv, _html} = live(conn, path)
      end
    end

    test "every collection mounts", %{conn: conn} do
      for collection <- PortfolioWeb.Admin.Collections.all() do
        assert {:ok, lv, _html} = live(conn, ~p"/admin/#{collection.slug}")
        assert has_element?(lv, "#admin-nav-#{collection.slug}[aria-current='page']")
      end
    end

    test "an unknown collection redirects to the dashboard", %{conn: conn} do
      assert {:error, {:live_redirect, %{to: "/admin", flash: %{"error" => _}}}} =
               live(conn, ~p"/admin/nope")
    end
  end
end
