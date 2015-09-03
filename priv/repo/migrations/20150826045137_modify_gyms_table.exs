defmodule Peergym.Repo.Migrations.ModifyGymsTable do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      remove :place_id
      remove :description
      add :google_place_id, :text
      add :address, :text
      add :phone_number, :integer
      add :hours, :text
      add :latitude, :float
      add :longitude, :float
      add :geographic_point, :geometry
    end
  end
end
