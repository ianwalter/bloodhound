defmodule Bloodhound.DeleteTest do
  use ExUnit.Case

  alias Bloodhound.Client
  alias Mix.Tasks.Bloodhound.Delete
  alias Bloodhound.Artist

  setup do
    Client.delete

    :ok
  end

  test "all documents can be deleted" do
    Client.index "test", %{id: 1, name: "All Falls Down"}
    Client.index "example", %{id: 2, name: "Can't Tell Me Nothing"}
    Delete.run []
    assert {:error, _} = Client.get "test", 5
    assert {:error, _} = Client.get "example", 2
  end

  @tag skip: "deleting all of a type requires a different query"
  test "all documents of a type can be deleted" do
    Client.index "test", %{id: 2, name: "All of the Lights"}
    Artist.index %Artist{id: 1, name: "Kanye West"}
    Delete.run ["Bloodhound.Artist"]

    :timer.sleep(100)

    assert {:ok, document} = Client.get "test", 2
    assert document.name === "All of the Lights"
    assert {:error, _} = Artist.get_index 1
  end

  test "a model's index can be deleted" do
    Artist.index %Artist{id: 2, name: "Matoma"}
    Delete.run ["Bloodhound.Artist", "2"]
    assert {:error, _} = Artist.get_index 2
  end
end
