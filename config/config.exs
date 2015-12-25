# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :peergym, Peergym.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "8vNwY7LhcY3hqsBLAP/m44potAU1CrR9f1dbqK1B7VgrMc3w6yFECjUbb2xBjHfi",
  debug_errors: false,
  pubsub: [name: Peergym.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Passport, our authentication system
config :passport,
  repo: Peergym.Repo,
  user_class: Peergym.User

config :arc,
  asset_host: "https://d2ohrei45269ks.cloudfront.net",
  access_key_id: "AKIAILAEHI3SP2ZZ55ZA",
  secret_access_key: "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",
  bucket: "peergym-photos"

city_db = [ __DIR__, "../priv/static/profiler/GeoLite2-City.mmdb" ]
  |> Path.join()
  |> Path.expand()

country_db = [ __DIR__, "../priv/static/profiler/GeoLite2-Country.mmdb" ]
  |> Path.join()
  |> Path.expand()

config :geolix,
  databases: [
    { :city,    city_db },
    { :country, country_db }
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
