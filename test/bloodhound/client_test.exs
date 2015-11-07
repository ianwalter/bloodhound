defmodule Bloodhound.ClientTest do
  use ExUnit.Case

  alias Bloodhound.Client

  setup do
    Client.delete
    :ok
  end

  doctest Client

  # test "a document can be indexed" do
  #   assert {:ok, _} = Client.index "test", %{id: 1, message: "Head South"}
  # end
  #
  # test "a document can be fetched" do
  #   Client.index "test", %{id: 2, message: "Never Ending Math Equation"}
  #   assert {:ok, document} = Client.get "test", 2
  #   assert document.message === "Never Ending Math Equation"
  # end
  #
  # test "a document can be deleted" do
  #   Client.index "test", %{id: 3, message: "The World At Large"}
  #   assert {:ok, _} = Client.delete "test", 3
  #   assert {:ok, 404} = Client.get "test", 3 # DA FUQ?!
  # end

  test "searching for documents by type returns documents of that type" do
    Client.index "test", %{id: 4, message: "Parting of the Sensory"}
    Client.index "test", %{id: 5, message: "People As Places As People"}
    assert {:ok, search} = Client.search "test"
    assert Enum.count(search.hits) === 2
    assert Enum.at search.hits, 1 == %{id: 5}
  end
end
