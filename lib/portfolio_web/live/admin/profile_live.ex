defmodule PortfolioWeb.Admin.ProfileLive do
  @moduledoc """
  Edits the singleton profile shown in the hero, nav, Elixir section and contact.
  """
  use PortfolioWeb, :live_view

  alias Portfolio.Content

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} active="profile">
      <.header>
        Profile
        <:subtitle>
          Shown in the nav, hero, Elixir section and contact. The stats under the hero are
          managed in <.link navigate={~p"/admin/hero-stats"} class="lnk font-semibold">Hero stats</.link>.
        </:subtitle>
      </.header>

      <.form
        for={@form}
        id="profile-form"
        phx-change="validate"
        phx-submit="save"
        class="max-w-[720px]"
      >
        <fieldset class="mb-8 border-t-2 border-ink pt-5">
          <legend class="pr-3 font-mono text-sm text-accent-text">// identity</legend>
          <.input field={@form[:name]} type="text" label="Name" />
          <.input
            field={@form[:role]}
            type="text"
            label="Role"
            placeholder="Software engineer"
          />
          <.input field={@form[:email]} type="email" label="Email" />
          <.input field={@form[:location]} type="text" label="Location" />
        </fieldset>

        <fieldset class="mb-8 border-t-2 border-ink pt-5">
          <legend class="pr-3 font-mono text-sm text-accent-text">// hero</legend>
          <.input field={@form[:headline]} type="text" label="Headline" />
          <.input field={@form[:intro]} type="textarea" label="Intro" rows="4" />
          <.input
            field={@form[:cta_label]}
            type="text"
            label="Email button label"
            placeholder="Say hello"
          />
          <.input
            field={@form[:learning_badge]}
            type="text"
            label="Learning badge (optional)"
            placeholder="now learning: Elixir + Phoenix"
          />
        </fieldset>

        <fieldset class="mb-8 border-t-2 border-ink pt-5">
          <legend class="pr-3 font-mono text-sm text-accent-text">// currently learning link</legend>
          <.input field={@form[:learning_link_label]} type="text" label="Link label (optional)" />
          <.input
            field={@form[:learning_link_url]}
            type="text"
            label="Link URL (optional)"
            placeholder="https://… or #contact"
          />
        </fieldset>

        <.button variant="primary" phx-disable-with="Saving…" id="profile-save">
          Save profile
        </.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    profile = Content.get_profile()

    {:ok,
     socket
     |> assign(:page_title, "Profile")
     |> assign(:profile, profile)
     |> assign(:form, to_form(Content.change_profile(profile)))}
  end

  @impl true
  def handle_event("validate", %{"profile" => params}, socket) do
    changeset = Content.change_profile(socket.assigns.profile, params)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"profile" => params}, socket) do
    case Content.save_profile(socket.assigns.profile, params) do
      {:ok, profile} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile saved.")
         |> assign(:profile, profile)
         |> assign(:form, to_form(Content.change_profile(profile)))}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
