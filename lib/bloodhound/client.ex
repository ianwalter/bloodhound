defmodule Bloodhound.Client do

  alias Poison.Parser

  @url Application.get_env :bloodhound, :elasticsearch_url
  @name Application.get_env :bloodhound, :index

  @doc """
  Indexes a document by inferring that it's ID is within it's data map.
  """
  def index(type, data), do: index(type, data.id, data)

  @doc """
  Adds a document to the index given it's type, ID, and a map with it's data.
  """
  def index(type, id, data) do
    encoded_data = Poison.encode! data
    type |> build_url(id) |> HTTPoison.put(encoded_data) |> parse_response
  end

  @doc """
  Gets a document given it's type and ID.
  """
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
  Searches an index and optionally index types.
  """
  def search(types \\ nil, data \\ %{}) do
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
    case status do
      :ok ->

        case body = Parser.parse!(response.body, keys: :atoms) do
          %{hits: hits} -> {:ok, format_hits hits}
          %{_source: _} -> {:ok, format_document body}
          %{error: _} -> {:error, body}
          %{found: false} -> {:error, body}
          _ -> {:ok, body}
        end

      _ -> {:error, response}
    end
  end

  @doc """
  Formats documents in search results to look like the models they represent.
  """
  def format_hits(hits) do
    %{hits | hits: Enum.map(hits.hits, &format_document/1)}
  end

  def format_document(document = %{_source: source}) do
    case Map.has_key?(document, :_score) do
      true -> Map.merge source, %{score: document._score, type: document._type}
      false -> source
    end
  end

  @doc """
  Calls ElasticSearch's Refresh API which: "...allows to explicitly refresh one
  or more indices, making all operations performed since the last refresh
  available for search".
  """
  def refresh(types \\ nil) do
    List.wrap(types)
    |> build_url("_refresh")
    |> HTTPoison.post("")
    |> parse_response
  end

end
