defmodule Portfolio.Content.Profile do
  @moduledoc """
  The portfolio owner's details. There is exactly one row.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :name, :string
    field :role, :string
    field :headline, :string
    field :intro, :string
    field :email, :string
    field :location, :string
    field :learning_badge, :string
    field :cta_label, :string
    field :learning_link_label, :string
    field :learning_link_url, :string

    timestamps(type: :utc_datetime)
  end

  @required ~w(name role headline intro email location cta_label)a
  @optional ~w(learning_badge learning_link_label learning_link_url)a

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/, message: "must be a valid email")
    |> Portfolio.Content.Validators.validate_url(:learning_link_url)
  end
end
