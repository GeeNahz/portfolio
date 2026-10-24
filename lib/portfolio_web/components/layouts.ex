defmodule PortfolioWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use PortfolioWeb, :html

  import PortfolioWeb.PortfolioComponents, only: [site_nav: 1, theme_switch: 1]

  alias PortfolioWeb.Admin.Collections

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders the public portfolio layout: the faint column grid, the site nav and flash.

  ## Examples

      <Layouts.public flash={@flash} profile={@profile} social_links={@social_links}>
        <section>…</section>
      </Layouts.public>
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  attr :profile, :map, required: true
  attr :social_links, :list, default: []

  slot :inner_block, required: true

  def public(assigns) do
    ~H"""
    <div class="gn-grid-bg min-h-screen overflow-x-hidden bg-paper text-[18px] leading-[1.55] text-ink">
      <.site_nav profile={@profile} social_links={@social_links} />
      <main>
        {render_slot(@inner_block)}
      </main>
      <.flash_group flash={@flash} />
    </div>
    """
  end

  @doc """
  Renders the management portal layout.

  Signed-in users get the admin navigation; signed-out pages (log in) get the
  top bar only.

  ## Examples

      <Layouts.app flash={@flash} current_scope={@current_scope} active="projects">
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  attr :active, :string, default: nil, doc: "the key of the highlighted admin nav item"

  slot :inner_block, required: true

  def app(assigns) do
    assigns = assign(assigns, :nav_items, admin_nav_items())

    ~H"""
    <div class="min-h-screen bg-paper text-ink">
      <header
        id="admin-topbar"
        class="flex flex-wrap items-center justify-between gap-x-6 gap-y-3 border-b-2 border-ink px-4 py-4 sm:px-8"
      >
        <.link
          navigate={if @current_scope, do: ~p"/admin", else: ~p"/"}
          class="flex items-baseline gap-3"
        >
          <span class="text-[22px] font-extrabold tracking-[-0.02em]">Portfolio</span>
          <span class="font-mono text-[13px] text-muted">/ admin</span>
        </.link>
        <div class="flex flex-wrap items-center gap-x-6 gap-y-3 font-mono text-sm">
          <a href={~p"/"} class="lnk" target="_blank" rel="noopener">View site ↗</a>
          <%= if @current_scope do %>
            <span class="hidden text-muted md:inline">{@current_scope.user.email}</span>
            <.link navigate={~p"/users/settings"} class="lnk">Settings</.link>
            <.link href={~p"/users/log-out"} method="delete" class="lnk" id="log-out">
              Log out
            </.link>
          <% end %>
          <.theme_switch />
        </div>
      </header>

      <div class="mx-auto flex max-w-[1280px] flex-col lg:flex-row">
        <nav
          :if={@current_scope}
          id="admin-nav"
          aria-label="Admin"
          class="shrink-0 border-b-2 border-ink p-4 lg:min-h-[calc(100vh-78px)] lg:w-64 lg:border-r-2 lg:border-b-0"
        >
          <ul class="m-0 flex list-none flex-wrap gap-1 p-0 font-mono text-sm lg:flex-col">
            <li :for={{key, label, path} <- @nav_items}>
              <.link
                navigate={path}
                id={"admin-nav-#{key}"}
                aria-current={if(@active == key, do: "page")}
                class={[
                  "flex min-h-11 items-center px-3 transition-colors",
                  if(@active == key, do: "bg-ink text-paper", else: "hover:bg-surface")
                ]}
              >
                {label}
              </.link>
            </li>
          </ul>
        </nav>

        <main class="min-w-0 flex-1 px-4 py-10 sm:px-8">
          {render_slot(@inner_block)}
        </main>
      </div>

      <.flash_group flash={@flash} />
    </div>
    """
  end

  defp admin_nav_items do
    [
      {"dashboard", "Dashboard", ~p"/admin"},
      {"profile", "Profile", ~p"/admin/profile"},
      {"sections", "Section copy", ~p"/admin/sections"}
    ] ++
      Enum.map(Collections.all(), fn collection ->
        {collection.slug, collection.title, ~p"/admin/#{collection.slug}"}
      end)
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end
end
