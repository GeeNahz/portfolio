defmodule Portfolio.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :years, :string, null: false
      add :category, :string, null: false
      add :summary, :text, null: false
      add :outcome, :text, null: false
      add :url, :string
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:projects, [:position])
  end
end
