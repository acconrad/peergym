use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :peergym, Peergym.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :comeonin, bcrypt_log_rounds: 4

# Configure your database
config :peergym, Peergym.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "peergym_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 1 # Use a single connection for transactional tests
