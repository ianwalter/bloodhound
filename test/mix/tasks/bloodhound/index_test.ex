defmodule Bloodhound.IndexTest do
  use ExUnit.Case

  alias Bloodhound.Client
  alias Mix.Tasks.Bloodhound.Index
  alias Bloodhound.Artist

  setup do
    Client.delete

    :ok
  end

  # test "all records of a model can be indexed" do
  #   Index.run ["Artist"]
  #
  #   # Refresh indices so documents are available for search
  #   Client.refresh
  #
  #   {:ok, %{hits: [document]}} = Artist.search
  #   assert document.name === "Phoenix"
  # end
end
