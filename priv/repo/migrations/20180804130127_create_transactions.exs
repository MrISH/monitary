defmodule Monitary.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :mun_id, :integer
      add :user_id, :integer
      add :amount_in_cents, :integer
      add :settlement_date, :naive_datetime
      add :classification, :integer
      add :source_id, :integer

      timestamps()
    end

  end
end
