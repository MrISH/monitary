defmodule Monitary.TransactionsItems do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions_items" do
    field :amount_in_cents, :integer
    field :item_id, :integer
    field :transaction_id, :integer
    field :user_id, :integer
    field :quantity, :integer

    timestamps()
  end

  @doc false
  def changeset(transactions_items, attrs) do
    transactions_items
    |> cast(attrs, [:transaction_id, :item_id, :user_id, :amount_in_cents, :quantity])
    |> validate_required([:transaction_id, :item_id, :user_id, :amount_in_cents, :quantity])
  end
end
