defmodule MonitaryWeb.TransactionChannel do
  use Phoenix.Channel

  alias Monitary.{
    Item,
    Repo,
    Transaction
  }

  def join("transaction:index", _params, socket) do
    {:ok, socket}
  end

  def handle_in("transaction:create", %{ "transaction" => transaction }, socket) do
    # Do a create
    transaction_struct = %Transaction{
      user_id:          socket.assigns[:user].id,
      mun_id:           String.to_integer(transaction["mun_id"]),
      amount_in_cents:  String.to_integer(transaction["amount_in_cents"]),
      settlement_date:  NaiveDateTime.from_iso8601!(transaction["settlement_date"] <> " 00:00:00"),
      classification:   String.to_integer(transaction["classification"]),
      source_id:        String.to_integer(transaction["source_id"]),
    }
    changeset  = Transaction.change_transaction(transaction_struct)
    # Respond with love
    case Repo.insert(changeset) do
      {:ok, transaction_record} ->
        # Send data to channel for rendering
        broadcast!(socket, "transaction:create", payload(transaction_record))
        {:reply, {:ok, payload(transaction_record)}, socket}
      {:error, changeset} ->
        {:error, %{reason: changeset.errors}}
    end
  end

  def handle_in("transaction:delete", %{ "id" => id }, socket) do
    transaction = Repo.get!(Transaction, id)

    case Repo.delete(transaction) do
      {:ok, _transaction} ->
        # Send data to channel for rendering
        broadcast!(socket, "transaction:delete", %{id: id})
        {:reply, {:ok, %{id: id}}, socket}
      {:error, id} ->
        {:error, %{reason: "No Transaction with ID #{id}"}}
    end
  end

  def handle_in("transaction:get_items", %{ "id" => id }, socket) do
    transaction = Repo.get!(Transaction, id)
    # Build array of item maps
    broadcast!(socket, "transaction:get_items", %{items: items_payload(transaction)})
    {:reply, {:ok, %{items: items_payload(transaction)}}, socket}
  end

  # def broadcast_create(transaction) do
  #   MonitaryWeb.Endpoint.broadcast("transaction:index", "transaction:created", payload(transaction))
  # end

  defp items_payload(transaction) do
    Repo.all(Ecto.assoc(transaction, :transactions_items))
    |> Enum.map( fn transaction_item ->
      %{
        id:              transaction_item.id,
        amount_in_cents: transaction_item.amount_in_cents,
        name:            Repo.get(Item, transaction_item.item_id).name,
        quantity:        transaction_item.quantity,
      }
    end)
  end

  defp payload(transaction) do
    %{
      id:               transaction.id,
      amount_in_cents:  transaction.amount_in_cents,
      classification:   transaction.classification,
      mun_id:           transaction.mun_id,
      settlement_date:  transaction.settlement_date,
      source_id:        transaction.source_id,
      user_id:          transaction.user_id,
    }
  end

end
