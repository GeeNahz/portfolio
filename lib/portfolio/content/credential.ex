defmodule Portfolio.Content.Credential do
  @moduledoc """
  An entry in the strip above contact: education, certification, teaching, tools.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "credentials" do
    field :kind, :string
    field :body, :string
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:kind, :body])
    |> validate_required([:kind, :body])
  end
end
