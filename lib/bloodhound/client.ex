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
  def delete(type, id) do
    type |> build_url(id) |> HTTPoison.delete |> parse_response
  end

  @doc """
  Searches an index and optionally a type.
  """
  def search(type, data \\ nil) do
    encoded_data = if data, do: Poison.encode! data, else: nil
    type |> build_url |> HTTPoison.post(encoded_data) |> parse_response
  end

  @doc """
    Constructs an ElasticSearch API URL.
    TODO investigate URL type, add params
  """
  def build_url(type, id \\ nil), do: "#{@url}/#{@name}/#{type}/#{id}"

  @doc """
  Parses a response from the ElasticSearch API into a happy map %{:)}.
  """
  def parse_response({status, response}) do
    body = Poison.Parser.encode! response.body, keys: :atoms!
    case status do
      :ok ->

        case body do
          %{hits: hits} -> {:ok, format_hits hits}
          %{found: true} -> {:ok, format_doument body}
          _ -> {:ok, response.status_code}
        end

      _ -> {:error, body}
    end
  end

end
