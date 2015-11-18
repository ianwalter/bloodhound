use Mix.Config

config :logger, level: :info

config :bloodhound,
  elasticsearch_url: "http://localhost:9200",
  index: "bloodhound_test"
