defmodule Portfolio.Content.SocialLink do
  @moduledoc """
  An external profile link (GitHub, LinkedIn, …) shown in the nav and/or contact section.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "social_links" do
    field :label, :string
    field :url, :string
    field :display_text, :string
    field :show_in_nav, :boolean, default: false
    field :show_in_contact, :boolean, default: true
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(link, attrs) do
    link
    |> cast(attrs, [:label, :url, :display_text, :show_in_nav, :show_in_contact])
    |> validate_required([:label, :url, :display_text])
    |> Portfolio.Content.Validators.validate_url(:url)
  end
end
