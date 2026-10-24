defmodule PortfolioWeb.HomeLive do
  @moduledoc """
  The public portfolio page.
  """
  use PortfolioWeb, :live_view

  import PortfolioWeb.PortfolioComponents

  alias Portfolio.Content
  alias Portfolio.Content.SectionCopy

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.public
      flash={@flash}
      current_scope={@current_scope}
      profile={@page.profile}
      social_links={@page.social_links}
    >
      <.hero profile={@page.profile} stats={@page.hero_stats} />
      <.stack_explorer
        copy={section(@page, "stack")}
        layers={@page.stack_layers}
        selected_id={@selected_layer_id}
      />
      <.systems_ledger copy={section(@page, "systems")} projects={@page.projects} />
      <.approach copy={section(@page, "approach")} principles={@page.principles} />
      <.elixir_section
        copy={section(@page, "elixir")}
        topics={@page.learning_topics}
        profile={@page.profile}
      />
      <.credentials_strip credentials={@page.credentials} />
      <.contact
        copy={section(@page, "contact")}
        profile={@page.profile}
        social_links={@page.social_links}
      />
    </Layouts.public>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    page = Content.home_page()
    first_layer = List.first(page.stack_layers)

    {:ok,
     socket
     |> assign(:page_title, page.profile.name)
     |> assign(:page, page)
     |> assign(:selected_layer_id, first_layer && first_layer.id)}
  end

  @impl true
  def handle_event("select_layer", %{"id" => id}, socket) do
    if Enum.any?(socket.assigns.page.stack_layers, &(&1.id == id)) do
      {:noreply, assign(socket, :selected_layer_id, id)}
    else
      {:noreply, socket}
    end
  end

  # Falls back to empty copy so a missing row never breaks the page.
  defp section(page, key) do
    Map.get(page.sections, key, %SectionCopy{key: key, eyebrow: "", heading: ""})
  end
end
