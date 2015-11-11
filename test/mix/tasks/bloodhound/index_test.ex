defmodule Bloodhound.IndexTest do
  use ExUnit.Case

  alias Bloodhound.Client
  alias Mix.Tasks.Bloodhound.Index
  alias Bloodhound.ExampleModel

  setup do
    Client.delete

    :ok
  end
  
  # test "all records of a model can be indexed" do
  #   Index.run ["ExampleModel"]
  #
  #   # Refresh indices so documents are available for search
  #   Client.refresh
  #
  #   {:ok, %{hits: [document]}} = ExampleModel.search
  #   assert document.message === "Chimes"
  # end
end
