defmodule Monitary.TransactionItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Monitary.TransactionItem

  schema "transactions_items" do
    field :amount_in_cents, :integer
    field :item_id, :integer
    field :transaction_id, :integer
    field :user_id, :integer
    field :quantity, :integer

    timestamps()
  end

  @doc false
  def changeset(transaction_item, attrs) do
    transaction_item
    |> cast(attrs, [:transaction_id, :item_id, :user_id, :amount_in_cents, :quantity])
    |> validate_required([:transaction_id, :item_id, :user_id, :amount_in_cents, :quantity])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(mun)
      %Ecto.Changeset{source: %TransactionItem{}}

  """
  def change_transaction(%TransactionItem{} = transaction_item) do
    TransactionItem.changeset(transaction_item, %{})
  end
end
