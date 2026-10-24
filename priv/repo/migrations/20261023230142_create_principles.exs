defmodule Portfolio.Repo.Migrations.CreatePrinciples do
  use Ecto.Migration

  def change do
    create table(:principles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :body, :text, null: false
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:principles, [:position])
  end
end
