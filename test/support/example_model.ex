defmodule Bloodhound.ExampleModel do
  use Bloodhound.Document
  use Ecto.Model

  import Ecto.Changeset

  schema "example_models" do
    field :message, :string
  end

  indexed_fields ~w(id message)
end
