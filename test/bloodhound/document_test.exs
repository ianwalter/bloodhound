defmodule Bloodhound.DocumentTest do
  use ExUnit.Case

  alias Bloodhound.Client
  alias Bloodhound.Document

  defmodule ExampleModel do
    use Document
    use Ecto.Model

    import Ecto.Changeset

    schema "example_models" do
      field :message, :string
    end

    indexed_fields ~w(id message)
  end

  setup do
    Client.delete

    :ok
  end

  doctest Document

  test "a model can be indexed" do
    changeset = %{ model: %ExampleModel{id: 1, message: "Sister Jack"} }
    assert changeset === ExampleModel.index changeset
    assert {:ok, document} = ExampleModel.get_index 1
    assert document.message === "Sister Jack"
  end

  test "a model's index can be fetched" do
    ExampleModel.index %ExampleModel{id: 2, message: "The Underdog"}
    assert {:ok, document} = ExampleModel.get_index 2
    assert document.message === "The Underdog"
  end

  test "a model's index can be deleted" do
    changeset = %{ model: %ExampleModel{id: 3, message: "Lines In The Suit"} }
    ExampleModel.index changeset
    assert changeset === ExampleModel.delete_index changeset
    assert {:error, %{status_code: 404}} = ExampleModel.get_index 2
  end

  test "searching by model will return document of it's type" do
    ExampleModel.index %ExampleModel{id: 4, message: "You Got Yr. Cherry Bomb"}
    Client.index "other", %{id: 1, message: "Operate"}

    # Refresh indices so documents are available for search
    Client.refresh

    assert {:ok, search} = ExampleModel.search
    assert Enum.count(search.hits) === 1
    assert Enum.at(search.hits, 0).message === "You Got Yr. Cherry Bomb"
  end

end
