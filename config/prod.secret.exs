use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :peergym, Peergym.Endpoint,
  secret_key_base: "kceYatgVZqioohOb3VkRFKn8+epAXW7PvmS85bdYrhHeyUP4eigdZD3txN3Ovoqe"

# Configure your database
config :peergym, Peergym.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "peergym_prod",
  size: 20 # The amount of database connections in the pool
