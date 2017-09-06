# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :peergym,
  ecto_repos: [Peergym.Repo]

# Configures the endpoint
config :peergym, Peergym.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: System.get_env("SECRET_KEY_CONFIG"),
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
  asset_host: System.get_env("ARC_S3_ASSET_HOST"),
  access_key_id: System.get_env("ARC_S3_KEY_ID"),
  secret_access_key: System.get_env("ARC_S3_ACCESS_KEY"),
  bucket: "peergym-photos"

config :geolix,
  databases: [
    %{
      id:      :city,
      adapter: Geolix.Adapter.MMDB2,
      source:  :filename.join(Path.dirname(__DIR__), "priv/static/profiler/GeoLite2-City.mmdb")
    },
    %{
      id:      :country,
      adapter: Geolix.Adapter.MMDB2,
      source:  :filename.join(Path.dirname(__DIR__), "priv/static/profiler/GeoLite2-Country.mmdb")
    }
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
