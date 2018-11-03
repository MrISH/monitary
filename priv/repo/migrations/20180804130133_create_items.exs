defmodule Monitary.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :user_id, :integer

      timestamps()
    end

    create unique_index(:items, [:name])
  end
end
