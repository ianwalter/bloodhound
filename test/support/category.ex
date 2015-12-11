defmodule Bloodhound.Category do
  use Bloodhound.Document
  use Ecto.Model

  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    belongs_to :artist, Bloodhound.Artist
  end

  indexed_fields ~w(id name)
end
