defmodule MonitaryWeb.MunController do
  use MonitaryWeb, :controller

  alias Monitary.Repo
  alias Monitary.Mun

  def delete(conn, %{ "id" => id }) do
    {id, _} = Integer.parse(id)

  end

  def edit(conn, %{ "id" => id }) do
    {id, _}   = Integer.parse(id)
    mun       = Repo.get_by(Mun, %{ id: id, user_id: current_user(conn).id })
    changeset = Mun.change_mun(mun)

    conn
      |> render("edit.html", changeset: changeset, action: mun_path(conn, :update, mun), mun: mun)
  end

  def index(conn, _params) do
    muns = Repo.all Ecto.assoc(current_user(conn), :muns)
    changeset = Mun.change_mun(%Mun{})

    conn
      |> put_flash(:info, "Welcome to Muns!, #{ current_user(conn).username }")
      |> render("index.html", muns: muns, changeset: changeset, action: "javascript:;")
      # |> render("index.html", muns: muns, changeset: changeset, action: mun_path(conn, :create))
  end

  def show(conn, %{ "id" => id }) do
    {id, _}   = Integer.parse(id)
    mun       = Repo.get_by(Mun, %{ id: id, user_id: current_user(conn).id })
    transactions = Repo.all Ecto.assoc(mun, :transactions)

    conn
      |> render("show.html", mun: mun, transactions: transactions)
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
        render conn, "edit.html", changeset: changeset, action: mun_path(conn, :update, mun), mun: mun
    end
  end

  defp current_user(conn) do
    Monitary.Auth.current_user(conn)
  end

end
