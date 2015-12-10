defmodule Bloodhound.DocumentTest do
  use ExUnit.Case

  alias Bloodhound.Client
  alias Bloodhound.Document
  alias Bloodhound.Artist

  setup do
    Client.delete

    :ok
  end

  doctest Document

  test "a model can be indexed and fetched" do
    artist = %Artist{id: 1, name: "Spoon"}
    assert {:ok, _} = Artist.index artist
    assert {:ok, document} = Artist.get_index artist.id
    assert document.name === artist.name
  end

  test "a model's index can be deleted" do
    artist = %Artist{id: 2, name: "Kid Cudi"}
    Artist.index artist
    assert {:ok, _} = Artist.delete_index artist
    assert {:error, _} = Artist.get_index artist.id
  end

  test "searching by model will return document of it's type" do
    artist = %Artist{id: 3, name: "Lauryn Hill"}
    Artist.index artist
    Client.index "other", %{id: 1, name: "Pablo Picasso"}

    # Refresh indices so documents are available for search
    Client.refresh

    assert {:ok, search} = Artist.search
    assert Enum.count(search.hits) === 1
    assert List.first(search.hits).name === artist.name
  end

end
