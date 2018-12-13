defmodule MonitaryWeb.MunChannel do
  use Phoenix.Channel

  alias Monitary.{
    Mun,
    Repo
  }

  def join("mun:index", _params, socket) do
    {:ok, socket}
  end

  def handle_in("mun:create", %{ "mun" => mun }, socket) do
    # Do a create
    mun_struct = %Mun{
      user_id:      socket.assigns[:user].id,
      name:         mun["name"],
      description:  mun["description"]
    }
    changeset  = Mun.change_mun(mun_struct)
    # Respond with love
    case Repo.insert(changeset) do
      {:ok, mun_record} ->
        # Send data to channel for rendering
        broadcast!(socket, "mun:create", payload(mun_record))
        {:reply, {:ok, payload(mun_record)}, socket}
      {:error, changeset} ->
        {:error, %{reason: changeset.errors}}
    end
  end

  def handle_in("mun:delete", %{ "id" => id }, socket) do
    mun = Repo.get!(Mun, id)

    case Repo.delete(mun) do
      {:ok, _mun} ->
        # Send data to channel for rendering
        broadcast!(socket, "mun:delete", %{id: id})
        {:reply, {:ok, %{id: id}}, socket}
      {:error, id} ->
        {:error, %{reason: "No Mun with ID #{id}"}}
    end
  end

  # def broadcast_create(mun) do
  #   MonitaryWeb.Endpoint.broadcast("mun:index", "mun:created", payload(mun))
  # end

  defp payload(mun) do
    %{
      id:           mun.id,
      name:         mun.name,
      description:  mun.description,
    }
  end

end
