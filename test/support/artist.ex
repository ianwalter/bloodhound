defmodule Bloodhound.Artist do
  use Bloodhound.Document
  use Ecto.Model

  import Ecto.Changeset

  schema "artists" do
    field :name, :string
    has_one :category, Bloodhound.Category
  end

  indexed_fields ~w(id name category)

  def changeset(artist, params \\ :empty) do
    artist |> cast(params, ~w(name))
  end
end
