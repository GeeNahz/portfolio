defmodule Portfolio.Content.StackLayer do
  @moduledoc """
  One tab of the "follow a request through the stack" explorer.

  `featured` layers use the violet, dashed "next layer" styling.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stack_layers" do
    field :label, :string
    field :heading, :string
    field :summary, :string
    field :highlights, {:array, :string}, default: []
    field :featured, :boolean, default: false
    field :link_label, :string
    field :link_url, :string
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(layer, attrs) do
    layer
    |> cast(attrs, [:label, :heading, :summary, :highlights, :featured, :link_label, :link_url])
    |> validate_required([:label, :heading, :summary])
    |> update_change(:highlights, &clean_highlights/1)
    |> Portfolio.Content.Validators.validate_url(:link_url)
  end

  defp clean_highlights(highlights) do
    highlights
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end
end
