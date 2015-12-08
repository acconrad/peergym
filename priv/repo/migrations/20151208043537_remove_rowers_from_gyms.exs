defmodule Peergym.Repo.Migrations.RemoveRowersFromGyms do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      remove :rowers
    end
  end
end
