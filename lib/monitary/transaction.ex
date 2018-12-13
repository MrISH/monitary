defmodule Monitary.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Monitary.{
    Auth.User,
    Item,
    Mun,
    Source,
    Transaction,
    TransactionItem
  }

  schema "transactions" do
    field :amount_in_cents, :integer
    field :classification, :integer
    field :settlement_date, :naive_datetime
    belongs_to :user, Auth.User
    belongs_to :mun, Mun
    belongs_to :source, Source
    has_many :transactions_items, TransactionItem
    many_to_many :items, Item, join_through: "transactions_items", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:mun_id, :user_id, :amount_in_cents, :settlement_date, :classification, :source_id])
    |> validate_required([:mun_id, :user_id, :amount_in_cents, :settlement_date, :classification, :source_id])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(mun)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end
end
