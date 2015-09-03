defmodule Peergym.Repo.Migrations.AddPlaceIdToGym do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      add :place_id, :string
    end
    create index(:gyms, [:place_id])
  end
end
