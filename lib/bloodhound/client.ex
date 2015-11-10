defmodule Bloodhound.Client do

  alias Poison.Parser

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
  def parse_response({status, %{body: body, status_code: code}}) do
    response = %{status_code: code, body: Parser.parse!(body, keys: :atoms)}
    case {status, code} do
      {:ok, code} when code in [200, 201, 204] ->

        case response.body do
          %{hits: hits} -> {:ok, format_hits hits}
          %{_source: _} -> {:ok, format_document response.body}
          _ -> {:ok, response}
        end

      _ -> {:error, response}
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
