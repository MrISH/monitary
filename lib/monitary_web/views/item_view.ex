defmodule MonitaryWeb.ItemView do
  use MonitaryWeb, :view

  alias Monitary.Repo
  alias Monitary.TransactionsItems
  alias Monitary.Item

  defp item_name(transaction_item) do
    Repo.get(Item, transaction_item.item_id).name
  end

end
