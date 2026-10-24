defmodule PortfolioWeb.Admin.CollectionLive do
  @moduledoc """
  Lists, orders, creates, edits and deletes the rows of one content collection.

  The collection comes from the `:collection` URL slug, looked up in
  `PortfolioWeb.Admin.Collections`.
  """
  use PortfolioWeb, :live_view

  alias Portfolio.Content
  alias PortfolioWeb.Admin.Collections

  @impl true
  def render(%{live_action: :index} = assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} active={@collection.slug}>
      <.header>
        {@collection.title}
        <:subtitle>{@collection.description}</:subtitle>
        <:actions>
          <.button
            navigate={~p"/admin/#{@collection.slug}/new"}
            variant="primary"
            id="new-item"
          >
            <.icon name="hero-plus" class="size-5" /> New {@collection.singular}
          </.button>
        </:actions>
      </.header>

      <p class="mb-4 font-mono text-[13px] text-muted">
        {@count} {if @count == 1, do: "item", else: "items"} · shown on the site in this order
      </p>

      <ol id="items" phx-update="stream" class="m-0 list-none border-t-2 border-ink p-0">
        <li id="items-empty" class="hidden py-8 text-muted only:block">
          Nothing here yet. Add the first {@collection.singular}.
        </li>
        <li
          :for={{dom_id, row} <- @streams.items}
          id={dom_id}
          class="flex flex-wrap items-center gap-x-5 gap-y-3 border-b-2 border-ink py-4"
        >
          <span class="w-8 font-mono text-sm text-muted">{ordinal(row.index)}</span>
          <div class="min-w-0 flex-[1_1_240px]">
            <div class="truncate text-lg font-semibold">
              {Map.get(row.item, @collection.title_field)}
            </div>
            <div
              :if={@collection.subtitle_field}
              class="truncate font-mono text-[13px] text-muted"
            >
              {Map.get(row.item, @collection.subtitle_field)}
            </div>
          </div>
          <div class="flex flex-wrap items-center gap-2">
            <.button
              type="button"
              phx-click="move"
              phx-value-id={row.item.id}
              phx-value-direction="up"
              disabled={row.first?}
              aria-label="Move up"
              id={"move-up-#{row.item.id}"}
              class="inline-flex size-11 cursor-pointer items-center justify-center border-2 border-ink bg-surface disabled:cursor-not-allowed disabled:opacity-30"
            >
              <.icon name="hero-arrow-up" class="size-5" />
            </.button>
            <.button
              type="button"
              phx-click="move"
              phx-value-id={row.item.id}
              phx-value-direction="down"
              disabled={row.last?}
              aria-label="Move down"
              id={"move-down-#{row.item.id}"}
              class="inline-flex size-11 cursor-pointer items-center justify-center border-2 border-ink bg-surface disabled:cursor-not-allowed disabled:opacity-30"
            >
              <.icon name="hero-arrow-down" class="size-5" />
            </.button>
            <.button
              navigate={~p"/admin/#{@collection.slug}/#{row.item.id}/edit"}
              id={"edit-#{row.item.id}"}
            >
              Edit
            </.button>
            <.button
              type="button"
              variant="danger"
              phx-click="delete"
              phx-value-id={row.item.id}
              data-confirm={"Delete this #{@collection.singular}? This can't be undone."}
              id={"delete-#{row.item.id}"}
            >
              Delete
            </.button>
          </div>
        </li>
      </ol>
    </Layouts.app>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} active={@collection.slug}>
      <.link
        navigate={~p"/admin/#{@collection.slug}"}
        class="lnk mb-6 inline-block font-mono text-sm"
        id="back-to-list"
      >
        ← {@collection.title}
      </.link>
      <.header>
        {if @live_action == :new,
          do: "New #{@collection.singular}",
          else: "Edit #{@collection.singular}"}
        <:subtitle>{@collection.description}</:subtitle>
      </.header>

      <.form
        for={@form}
        id="item-form"
        phx-change="validate"
        phx-submit="save"
        class="max-w-[720px]"
      >
        <div :for={field <- @collection.fields}>
          <%= if field.type == "lines" do %>
            <.input
              field={@form[field.name]}
              type="textarea"
              label={field.label}
              value={lines_value(@form[field.name].value)}
              rows="6"
            />
          <% else %>
            <.input
              field={@form[field.name]}
              type={field.type}
              label={field.label}
              rows={if(field.type == "textarea", do: "4")}
            />
          <% end %>
          <p :if={field[:help]} class="-mt-2 mb-5 text-sm text-muted">{field.help}</p>
        </div>

        <div class="flex flex-wrap gap-3">
          <.button variant="primary" phx-disable-with="Saving…" id="item-save">
            Save {@collection.singular}
          </.button>
          <.button navigate={~p"/admin/#{@collection.slug}"}>Cancel</.button>
        </div>
      </.form>
    </Layouts.app>
    """
  end

  defp lines_value(value) when is_list(value), do: Enum.join(value, "\n")
  defp lines_value(value), do: value

  defp ordinal(index), do: PortfolioWeb.PortfolioComponents.ordinal(index)

  @impl true
  def mount(%{"collection" => slug}, _session, socket) do
    case Collections.fetch(slug) do
      {:ok, collection} ->
        {:ok, assign(socket, :collection, collection)}

      :error ->
        {:ok,
         socket
         |> put_flash(:error, "There is no “#{slug}” section to manage.")
         |> push_navigate(to: ~p"/admin")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    if socket.assigns[:collection] do
      {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    else
      {:noreply, socket}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, socket.assigns.collection.title)
    |> stream_items()
  end

  defp apply_action(socket, :new, _params) do
    item = struct(socket.assigns.collection.schema)

    socket
    |> assign(:page_title, "New #{socket.assigns.collection.singular}")
    |> assign(:item, item)
    |> assign(:form, to_form(Content.change(item), as: "item"))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    item = Content.get!(socket.assigns.collection.schema, id)

    socket
    |> assign(:page_title, "Edit #{socket.assigns.collection.singular}")
    |> assign(:item, item)
    |> assign(:form, to_form(Content.change(item), as: "item"))
  end

  @impl true
  def handle_event("validate", %{"item" => params}, socket) do
    params = Collections.normalize_params(socket.assigns.collection, params)
    changeset = Content.change(socket.assigns.item, params)
    {:noreply, assign(socket, :form, to_form(changeset, as: "item", action: :validate))}
  end

  def handle_event("save", %{"item" => params}, socket) do
    %{collection: collection, item: item, live_action: action} = socket.assigns
    params = Collections.normalize_params(collection, params)

    result =
      if action == :new,
        do: Content.create(collection.schema, params),
        else: Content.update(item, params)

    case result do
      {:ok, _item} ->
        {:noreply,
         socket
         |> put_flash(:info, "#{String.capitalize(collection.singular)} saved.")
         |> push_navigate(to: ~p"/admin/#{collection.slug}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset, as: "item"))}
    end
  end

  def handle_event("move", %{"id" => id, "direction" => direction}, socket)
      when direction in ["up", "down"] do
    item = Content.get!(socket.assigns.collection.schema, id)
    {:ok, _} = Content.move(item, String.to_existing_atom(direction))
    {:noreply, stream_items(socket)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    %{collection: collection} = socket.assigns
    {:ok, _} = collection.schema |> Content.get!(id) |> Content.delete()

    {:noreply,
     socket
     |> put_flash(:info, "#{String.capitalize(collection.singular)} deleted.")
     |> stream_items()}
  end

  # Positions and first/last flags change on every reorder or delete, so the
  # whole list is re-streamed.
  defp stream_items(socket) do
    items = Content.list(socket.assigns.collection.schema)
    last_index = length(items) - 1

    rows =
      items
      |> Enum.with_index()
      |> Enum.map(fn {item, index} ->
        %{id: item.id, item: item, index: index, first?: index == 0, last?: index == last_index}
      end)

    socket
    |> assign(:count, length(items))
    |> stream(:items, rows, reset: true)
  end
end
