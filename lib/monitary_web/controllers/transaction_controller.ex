defmodule MonitaryWeb.TransactionController do
  use MonitaryWeb, :controller

  alias Monitary.Repo
  alias Monitary.Mun

  def index(conn, %{"mun_id" => mun_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    mun = Repo.get_by(Mun, %{user_id: current_user.id, id: mun_id})
    transactions = Repo.all Ecto.assoc(mun, :transactions)

    render conn, "index.html", mun: mun, transactions: transactions
  end
end
