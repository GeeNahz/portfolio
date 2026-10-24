defmodule Portfolio.Repo.Migrations.CreateSectionCopies do
  use Ecto.Migration

  def change do
    create table(:section_copies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :key, :string, null: false
      add :eyebrow, :string, null: false
      add :heading, :string, null: false
      add :intro, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:section_copies, [:key])
  end
end
