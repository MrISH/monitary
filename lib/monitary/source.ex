defmodule Monitary.Source do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sources" do
    field :name, :string
    has_many :transactions, Monitary.Transaction

    timestamps()
  end

  @doc false
  def changeset(source, attrs) do
    source
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
