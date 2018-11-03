defmodule Monitary.Repo.Migrations.CreateSources do
  use Ecto.Migration

  def change do
    create table(:sources) do
      add :name, :string

      timestamps()
    end

    create unique_index(:sources, [:name])
  end
end
