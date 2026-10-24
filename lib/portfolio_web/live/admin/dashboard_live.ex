defmodule PortfolioWeb.Admin.DashboardLive do
  @moduledoc """
  Overview of every editable area of the portfolio.
  """
  use PortfolioWeb, :live_view

  alias Portfolio.Content
  alias PortfolioWeb.Admin.Collections

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} active="dashboard">
      <.header>
        Manage your portfolio
        <:subtitle>Everything on the public page comes from these areas.</:subtitle>
        <:actions>
          <.button href={~p"/"} target="_blank" rel="noopener" variant="primary">
            View site ↗
          </.button>
        </:actions>
      </.header>

      <div
        :if={!@profile_set?}
        id="profile-missing"
        class="mb-8 border-2 border-accent-text bg-surface p-4"
      >
        Your profile isn't set up yet, so the hero and contact sections are empty.
        <.link navigate={~p"/admin/profile"} class="lnk font-semibold">Create it now →</.link>
      </div>

      <div
        id="admin-areas"
        class="grid grid-cols-[repeat(auto-fill,minmax(min(260px,100%),1fr))] gap-5"
      >
        <.area_card
          id="area-profile"
          title="Profile"
          section="Hero & contact"
          description="Name, role, headline, intro, email, location and the learning badge."
          path={~p"/admin/profile"}
          meta={if @profile_set?, do: "set up", else: "not set up"}
        />
        <.area_card
          id="area-sections"
          title="Section copy"
          section="All sections"
          description="The eyebrow, heading and intro of each section."
          path={~p"/admin/sections"}
          meta={"#{@section_count} sections"}
        />
        <.area_card
          :for={collection <- @collections}
          id={"area-#{collection.slug}"}
          title={collection.title}
          section={collection.section}
          description={collection.description}
          path={~p"/admin/#{collection.slug}"}
          meta={"#{collection.count} #{if collection.count == 1, do: "item", else: "items"}"}
        />
      </div>
    </Layouts.app>
    """
  end

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :section, :string, required: true
  attr :description, :string, required: true
  attr :path, :string, required: true
  attr :meta, :string, required: true

  defp area_card(assigns) do
    ~H"""
    <.link
      navigate={@path}
      id={@id}
      class="btn-brut flex flex-col gap-3 border-2 border-ink bg-surface p-5"
    >
      <span class="font-mono text-[13px] text-accent-text">// {@section}</span>
      <span class="text-2xl leading-tight font-extrabold tracking-[-0.02em]">{@title}</span>
      <span class="text-muted">{@description}</span>
      <span class="mt-auto border-t-2 border-ink pt-3 font-mono text-[13px]">{@meta} →</span>
    </.link>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    collections =
      Enum.map(Collections.all(), &Map.put(&1, :count, Content.count(&1.schema)))

    {:ok,
     socket
     |> assign(:page_title, "Admin")
     |> assign(:profile_set?, Content.get_profile().id != nil)
     |> assign(:section_count, length(Content.list_section_copies()))
     |> assign(:collections, collections)}
  end
end
