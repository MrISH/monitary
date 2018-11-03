defmodule Monitary.Item do
  use Ecto.Schema
  import Ecto.Changeset


  schema "items" do
    field :name, :string
    field :user_id, :integer
    many_to_many :transactions, Monitary.Transaction, join_through: "transactions_items"

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name)
  end
end
