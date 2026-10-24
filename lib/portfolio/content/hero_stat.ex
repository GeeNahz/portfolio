defmodule Portfolio.Content.HeroStat do
  @moduledoc """
  A short fact in the strip under the hero, e.g. "62 courts".
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "hero_stats" do
    field :label, :string
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(stat, attrs) do
    stat
    |> cast(attrs, [:label])
    |> validate_required([:label])
    |> validate_length(:label, max: 60)
  end
end
