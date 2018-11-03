defmodule Monitary.Mun do
  use Ecto.Schema
  import Ecto.Changeset



  schema "muns" do
    field :description, :string
    field :name, :string
    belongs_to :user, Monitary.Auth.User
    has_many :transactions, Monitary.Transaction

    timestamps()
  end

  @doc false
  def changeset(mun, attrs) do
    mun
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :description, :user_id])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mun changes.

  ## Examples

      iex> change_mun(mun)
      %Ecto.Changeset{source: %Mun{}}

  """
  def change_mun(%Monitary.Mun{} = mun) do
    Monitary.Mun.changeset(mun, %{})
  end
end
