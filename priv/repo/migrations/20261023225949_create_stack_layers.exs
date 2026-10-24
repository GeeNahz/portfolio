defmodule Portfolio.Repo.Migrations.CreateStackLayers do
  use Ecto.Migration

  def change do
    create table(:stack_layers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :label, :string, null: false
      add :heading, :string, null: false
      add :summary, :text, null: false
      add :highlights, {:array, :text}, null: false, default: []
      add :featured, :boolean, null: false, default: false
      add :link_label, :string
      add :link_url, :string
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:stack_layers, [:position])
  end
end
