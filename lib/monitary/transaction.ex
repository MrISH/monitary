defmodule Monitary.Transaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :amount_in_cents, :integer
    field :classification, :integer
    field :settlement_date, :naive_datetime
    belongs_to :user, Monitary.Auth.User
    belongs_to :mun, Monitary.Mun
    belongs_to :source, Monitary.Source
    has_many :transactions_items, Monitary.TransactionsItems
    many_to_many :items, Monitary.Item, join_through: "transactions_items", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:mun_id, :user_id, :amount_in_cents, :settlement_date, :classification, :source_id])
    |> validate_required([:mun_id, :user_id, :amount_in_cents, :settlement_date, :classification, :source_id])
  end
end
