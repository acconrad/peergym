ExUnit.start
Application.ensure_all_started(:ex_machina)
# Create the database, run migrations, and start the test transaction.
Ecto.Adapters.SQL.Sandbox.mode(Peergym.Repo, :manual)
