defmodule Bloodhound.Document do

  defmacro indexed_fields(fields) do
    quote do
      @indexed_fields Enum.map(unquote(fields), &String.to_atom/1)
      def indexed_fields, do: @indexed_fields
    end
  end

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)

      def index_type, do: __MODULE__.__schema__(:source)

      @doc """
      Indexes a model within a given changeset.
      """
      def index(changeset = %{model: model}) do
        index model
        changeset
      end

      @doc """
      Indexes a model.
      """
      def index(model) do
        Bloodhound.Client.index index_type, to_map(model, indexed_fields)
      end

      @doc """
      Indexes a model.
      """
      def get_index(id) do
        Bloodhound.Client.get index_type, id
      end

      @doc """
      """
      def delete_index(changeset = %{model: model}) do
        delete_index model
        changeset
      end

      @doc """
      """
      def delete_index(model) do
        Bloodhound.Client.delete index_type, model.id
      end

      @doc """
      """
      def search(query \\ %{}), do: Bloodhound.Client.search(index_type, query)
    end
  end

  @doc """
  """
  def to_map(model, fields \\ nil) do
    case fields do
      nil -> Map.from_struct model
      fields -> model |> Map.from_struct |> Map.take(fields)
    end
  end

end
