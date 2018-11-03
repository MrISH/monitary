defmodule Monitary.Repo.Migrations.CreateTransactionsItems do
  use Ecto.Migration

  def change do
    create table(:transactions_items) do
      add :transaction_id, :integer
      add :item_id, :integer
      add :user_id, :integer
      add :amount_in_cents, :integer
      add :quantity, :integer

      timestamps()
    end

    create unique_index(:transactions_items, [:transaction_id, :item_id])
  end
end
