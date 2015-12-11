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
      Indexes a model.
      """
      def index(model) do
        Bloodhound.Client.index index_type, to_index_map(model)
      end

      @doc """
      TODO
      """
      def get_index(id) do
        Bloodhound.Client.get index_type, id
      end

      @doc """
      """
      def delete_index(model \\ nil) do
        case model do
          m when is_map(m) -> Bloodhound.Client.delete index_type, m.id
          id -> Bloodhound.Client.delete index_type, id
        end
      end

      @doc """
      """
      def search(query \\ %{}), do: Bloodhound.Client.search(index_type, query)

      @doc """
      """
      def to_index_map({key, value}) do
        if is_map(value) do
          {key, to_index_map(value)}
        else
          {key, value}
        end
      end

      @doc """
      """
      def to_index_map(model) when is_map(model) do
        if Map.has_key? model, :__struct__ do
          case {:indexed_fields, 0} in model.__struct__.__info__(:functions) do
            true ->
              model = model
              |> Map.from_struct
              |> Map.take(model.__struct__.indexed_fields)
            false -> model = Map.from_struct model
          end
        end
        Enum.into Enum.map(model, &to_index_map/1), %{}
      end

    end
  end

end
