defmodule Portfolio.Repo.Migrations.CreateSocialLinks do
  use Ecto.Migration

  def change do
    create table(:social_links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :label, :string, null: false
      add :url, :string, null: false
      add :display_text, :string, null: false
      add :show_in_nav, :boolean, null: false, default: false
      add :show_in_contact, :boolean, null: false, default: true
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:social_links, [:position])
  end
end
