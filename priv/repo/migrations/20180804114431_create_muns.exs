defmodule Monitary.Repo.Migrations.CreateMuns do
  use Ecto.Migration

  def change do
    create table(:muns) do
      add :name, :string
      add :description, :string
      add :user_id, :integer

      timestamps()
    end

    create unique_index(:muns, [:name])
  end
end
