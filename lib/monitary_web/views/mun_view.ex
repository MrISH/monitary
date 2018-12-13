defmodule MonitaryWeb.MunView do
  use MonitaryWeb, :view

  alias Monitary.Repo
  alias Monitary.Source

  defp classify(transaction) do
    %{ 1 => "Incoming", 2 => "Outgoing" }
    |> Map.get(transaction.classification)
  end

  defp currencify(cents) do
    cents
    # |> Integer.to_string()
    # |> String.split_at(-2)
  end

  defp source_name(source_id) do
    Repo.get(Source, source_id).name
  end
end
