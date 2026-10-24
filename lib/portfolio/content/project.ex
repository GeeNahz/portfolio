defmodule Portfolio.Content.Project do
  @moduledoc """
  A row of the "systems shipped" ledger.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "projects" do
    field :name, :string
    field :years, :string
    field :category, :string
    field :summary, :string
    field :outcome, :string
    field :url, :string
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :years, :category, :summary, :outcome, :url])
    |> validate_required([:name, :years, :category, :summary, :outcome])
    |> Portfolio.Content.Validators.validate_url(:url)
  end
end
