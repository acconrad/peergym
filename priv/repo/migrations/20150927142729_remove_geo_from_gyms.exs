defmodule Peergym.Repo.Migrations.RemoveGeoFromGyms do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      remove :geographic_point
    end
  end
end
