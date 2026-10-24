defmodule Portfolio.Content.SectionCopy do
  @moduledoc """
  The eyebrow, heading and optional intro for each public page section.

  Rows are keyed by section and created by the seeds; the admin edits them but
  never adds or removes them.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @keys ~w(stack systems approach elixir contact)

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "section_copies" do
    field :key, :string
    field :eyebrow, :string
    field :heading, :string
    field :intro, :string

    timestamps(type: :utc_datetime)
  end

  def keys, do: @keys

  def changeset(copy, attrs) do
    copy
    |> cast(attrs, [:eyebrow, :heading, :intro])
    |> validate_required([:eyebrow, :heading])
  end

  @doc false
  def create_changeset(copy, attrs) do
    copy
    |> cast(attrs, [:key])
    |> validate_required([:key])
    |> validate_inclusion(:key, @keys)
    |> unique_constraint(:key)
    |> changeset(attrs)
  end
end
