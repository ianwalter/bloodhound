defmodule Bloodhound.ClientTest do
  use ExUnit.Case

  alias Bloodhound.Client

  doctest Client

  test "a document gets indexed" do
    assert {:ok, _} = Client.index "test", %{id: 1, message: "Head South"}
  end
end
