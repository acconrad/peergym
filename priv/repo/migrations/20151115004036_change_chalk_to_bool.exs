defmodule Peergym.Repo.Migrations.ChangeChalkToBool do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      remove :gym_chalk
      add :gym_chalk, :boolean
    end
  end
end
