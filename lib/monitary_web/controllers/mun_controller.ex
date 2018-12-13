defmodule MonitaryWeb.MunController do
  use MonitaryWeb, :controller

  alias Monitary.Repo
  alias Monitary.{
    Mun,
    Source,
    Transaction,
    TransactionItem,
  }

  def delete(_conn, %{ "id" => id }) do
    # Find user, find user's muns, then delete if all good
    # Probably unneccesary because all stuff is done in muns channel
    {_id, _} = Integer.parse(id)
  end

  def edit(conn, %{ "id" => id }) do
    {id, _}   = Integer.parse(id)
    mun       = Repo.get_by(Mun, %{ id: id, user_id: current_user(conn).id })
    changeset = Mun.change_mun(mun)

    conn
      |> render("edit.html",
        changeset:  changeset,
        action:     mun_path(conn, :update, mun),
        mun:        mun
      )
  end

  def index(conn, _params) do
    muns = Repo.all Ecto.assoc(current_user(conn), :muns)
    changeset = Mun.change_mun(%Mun{})

    conn
      |> put_flash(:info, "Welcome to Muns!, #{ current_user(conn).username }")
      |> render("index.html", muns: muns, changeset: changeset, action: "javascript:;")
  end

  def show(conn, %{ "id" => id }) do
    {id, _}      = Integer.parse(id)
    mun          = Repo.get_by(Mun, %{ id: id, user_id: current_user(conn).id })
    transactions = Repo.all Ecto.assoc(mun, :transactions)
    changeset    = Transaction.change_transaction(%Transaction{})
    ti_changeset = TransactionItem.change_transaction(%TransactionItem{})

    sources      =
      Source
      |> Repo.all()
      |> Enum.map(fn s -> [key: s.name, value: s.id] end)

    conn
      |> render("show.html",
        mun:          mun,
        transactions: transactions,
        sources:      sources,
        changeset:    changeset,
        ti_changeset: ti_changeset,
        action:       "javascript:;"
      )
  end

  def update(conn, %{ "id" => id, "mun" => %{ "name" => name, "description" => description } }) do
    {id, _}       = Integer.parse(id)
    mun           = Repo.get_by(Mun, %{ id: id, user_id: current_user(conn).id })
    changeset     = Mun.change_mun(%Mun{ id: id, user_id: current_user(conn).id, name: name, description: description })
    IO.puts changeset.valid?

    case Repo.update(changeset) do
      {:ok, mun} ->
        conn
          |> put_flash(:info, "#{ mun.name } updated successfully!")
          |> redirect(to: mun_path(conn, :show, mun))
      {:error, changeset} ->
        conn
        |> render("edit.html",
          changeset:  changeset,
          action:     mun_path(conn, :update, mun),
          mun:        mun
        )
    end
  end

  defp current_user(conn) do
    Monitary.Auth.current_user(conn)
  end

end
