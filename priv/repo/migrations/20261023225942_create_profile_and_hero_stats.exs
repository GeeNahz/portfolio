defmodule Portfolio.Repo.Migrations.CreateProfileAndHeroStats do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :role, :string, null: false
      add :headline, :string, null: false
      add :intro, :text, null: false
      add :email, :string, null: false
      add :location, :string, null: false
      add :learning_badge, :string
      add :cta_label, :string, null: false
      add :learning_link_label, :string
      add :learning_link_url, :string

      timestamps(type: :utc_datetime)
    end

    create table(:hero_stats, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :label, :string, null: false
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:hero_stats, [:position])
  end
end
