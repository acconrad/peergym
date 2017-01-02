use Mix.Config

config :peergym, Peergym.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "peergym.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

config :comeonin, bcrypt_log_rounds: 14

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :peergym, Peergym.Endpoint, server: true
#

# Configure your database
config :peergym, Peergym.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 18 # The amount of database connections in the pool
