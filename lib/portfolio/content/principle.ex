defmodule Portfolio.Content.Principle do
  @moduledoc """
  A habit in the "how I think" approach section.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "principles" do
    field :title, :string
    field :body, :string
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(principle, attrs) do
    principle
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
