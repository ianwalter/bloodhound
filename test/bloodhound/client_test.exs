defmodule Bloodhound.ClientTest do
  use ExUnit.Case

  alias Bloodhound.Client

  setup do
    Client.delete

    :ok
  end

  doctest Client

  test "a document can be indexed" do
    assert {:ok, _} = Client.index "test", %{id: 1, message: "Head South"}
  end

  test "a document can be fetched" do
    Client.index "test", %{id: 2, message: "Never Ending Math Equation"}
    assert {:ok, document} = Client.get "test", 2
    assert document.message === "Never Ending Math Equation"
  end

  test "a document can be deleted" do
    Client.index "test", %{id: 3, message: "The World At Large"}
    assert {:ok, _} = Client.delete "test", 3
    assert {:error, _} = Client.get "test", 3
  end

  test "all documents of a type can be deleted" do
    Client.index "test", %{id: 4, message: "Lampshades On Fire"}
    Client.index "example", %{id: 1, message: "11th Dimension"}
    assert {:ok, _} = Client.delete "test"
    assert {:error, _} = Client.get "test", 4
    assert {:ok, control} = Client.get "example", 1
    assert control.message === "11th Dimension"
  end

  test "all documents can be deleted" do
    Client.index "test", %{id: 5, message: "Lampshades On Fire"}
    Client.index "example", %{id: 2, message: "11th Dimension"}
    assert {:ok, _} = Client.delete
    assert {:error, _} = Client.get "test", 5
    assert {:error, _} = Client.get "example", 2
  end

  test "searching for documents by type returns documents of that type" do
    Client.index "example", %{id: 3, message: ""}
    Client.index "test", %{id: 4, message: "Parting of the Sensory"}
    Client.index "test", %{id: 5, message: "People As Places As People"}

    # Refresh indices so documents are available for search
    Client.refresh

    assert {:ok, search} = Client.search "test"
    assert Enum.count(search.hits) === 2
    assert Enum.at(search.hits, 1).message == "People As Places As People"
  end
end
