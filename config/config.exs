use Mix.Config

config :bloodhound, elasticsearch_url: "http://localhost:9200"

if Mix.env === :test, do: import_config "test.exs"
