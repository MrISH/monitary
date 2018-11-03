defmodule MonitaryWeb.ItemController do
  use MonitaryWeb, :controller

  alias Monitary.Repo
  alias Monitary.Mun
  alias Monitary.Transaction

  def index(conn, %{"mun_id" => mun_id, "transaction_id" => transaction_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    mun = Repo.get_by(Mun, %{user_id: current_user.id, id: mun_id})
    transaction = Repo.get_by(Transaction, %{mun_id: mun.id, id: transaction_id})
    transaction_items = Repo.all Ecto.assoc(transaction, :transactions_items)

    render conn, "index.html", mun: mun, transaction: transaction, transaction_items: transaction_items
  end
end
