defmodule PortfolioWeb.Admin.SectionsLive do
  @moduledoc """
  Edits the eyebrow, heading and intro of each public page section.
  """
  use PortfolioWeb, :live_view

  alias Portfolio.Content

  @labels %{
    "stack" => "Stack explorer",
    "systems" => "Systems ledger",
    "approach" => "Approach",
    "elixir" => "Currently learning",
    "contact" => "Contact"
  }

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} active="sections">
      <.header>
        Section copy
        <:subtitle>
          The eyebrow is shown as a <code class="font-mono">// comment</code> above each heading.
        </:subtitle>
      </.header>

      <p :if={@sections == []} id="sections-empty" class="text-muted">
        No section copy yet. Run <code class="font-mono">mix run priv/repo/seeds.exs</code>
        to create it.
      </p>

      <div class="flex max-w-[720px] flex-col gap-10">
        <.form
          :for={{copy, form} <- @sections}
          for={form}
          id={"section-form-#{copy.key}"}
          phx-change="validate"
          phx-submit="save"
          class="border-t-2 border-ink pt-5"
        >
          <h2 class="mt-0 mb-4 text-2xl font-extrabold tracking-[-0.02em]">
            {Map.get(@labels, copy.key, copy.key)}
          </h2>
          <input type="hidden" name="section_id" value={copy.id} />
          <.input field={form[:eyebrow]} type="text" label="Eyebrow" />
          <.input field={form[:heading]} type="text" label="Heading" />
          <.input field={form[:intro]} type="textarea" label="Intro (optional)" rows="3" />
          <.button phx-disable-with="Saving…" id={"section-save-#{copy.key}"}>
            Save {String.downcase(Map.get(@labels, copy.key, copy.key))}
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    sections =
      Enum.map(Content.list_section_copies(), fn copy ->
        {copy, build_form(copy, Content.change_section_copy(copy))}
      end)

    {:ok,
     socket
     |> assign(:page_title, "Section copy")
     |> assign(:labels, @labels)
     |> assign(:sections, sections)}
  end

  @impl true
  def handle_event("validate", %{"section_id" => id, "section" => params}, socket) do
    {:noreply,
     update_section(socket, id, fn copy ->
       {copy, build_form(copy, Content.change_section_copy(copy, params), :validate)}
     end)}
  end

  def handle_event("save", %{"section_id" => id, "section" => params}, socket) do
    copy = Content.get_section_copy!(id)

    case Content.update_section_copy(copy, params) do
      {:ok, copy} ->
        {:noreply,
         socket
         |> put_flash(:info, "#{Map.get(@labels, copy.key, copy.key)} copy saved.")
         |> update_section(id, fn _ ->
           {copy, build_form(copy, Content.change_section_copy(copy))}
         end)}

      {:error, changeset} ->
        {:noreply, update_section(socket, id, fn _ -> {copy, build_form(copy, changeset)} end)}
    end
  end

  defp build_form(copy, changeset) do
    to_form(changeset, as: "section", id: "section-#{copy.key}")
  end

  defp build_form(copy, changeset, action) do
    to_form(changeset, as: "section", id: "section-#{copy.key}", action: action)
  end

  defp update_section(socket, id, fun) do
    sections =
      Enum.map(socket.assigns.sections, fn
        {%{id: ^id} = copy, _form} -> fun.(copy)
        other -> other
      end)

    assign(socket, :sections, sections)
  end
end
