defmodule Bloodhound.Client do

  @url Application.get_env :bloodhound, :elasticsearch_url
  @name Application.get_env :bloodhound, :index

  def index(type, data), do: index(type, data.id, data)

  def index(type, id, data) do
    encoded_data = Poison.encode! data
    type |> build_url(id) |> HTTPoison.put(encoded_data) |> parse_response
  end

  def get(type, id) do
    type |> build_url(id) |> HTTPoison.get |> parse_response
  end

  @doc """
  Deletes a document given a document type and ID.
  """
  def delete(type \\ nil, id \\ nil) do
    type |> build_url(id) |> HTTPoison.delete |> parse_response
  end

  @doc """
  Searches an index and optionally a type.
  """
  def search(types \\ nil, data \\ %{}) do
    IO.puts List.wrap(types) |> build_url("_search")
    List.wrap(types)
    |> build_url("_search")
    |> HTTPoison.post(Poison.encode! data)
    |> parse_response
  end

  @doc """
    Constructs an ElasticSearch API URL.
    TODO add params
  """
  def build_url(type, id \\ nil) do
    List.flatten([@url, @name, type, id])
    |> Enum.filter(&(&1))
    |> Enum.join("/")
  end

  @doc """
  Parses a response from the ElasticSearch API into a happy map %{:)}.
  """
  def parse_response({status, response}) do
    IO.inspect response
    body = Poison.Parser.parse! response.body, keys: :atoms
    case status do
      :ok ->

        case body do
          %{hits: hits} -> {:ok, format_hits hits}
          %{_source: _} -> {:ok, format_document body}
          _ -> {:ok, response.status_code}
        end

      _ -> {:error, body}
    end
  end

  def format_hits(hits) do
    %{hits | hits: Enum.map(hits.hits, &format_document/1)}
  end

  def format_document(document = %{_source: source}) do
    case Map.has_key?(document, :_score) do
      true -> Map.merge source, %{score: document._score, type: document._type}
      false -> source
    end
  end

end
