defmodule Portfolio.Content.LearningTopic do
  @moduledoc """
  A topic in the "currently learning" (Elixir) section.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "learning_topics" do
    field :title, :string
    field :body, :string
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
