defmodule Peergym.Repo.Migrations.AddPhotosToGyms do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      add :photos, :string
    end
  end
end
