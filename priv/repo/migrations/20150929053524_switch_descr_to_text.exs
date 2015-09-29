defmodule Peergym.Repo.Migrations.SwitchDescrToText do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      remove :description
      add :description, :text
    end
  end
end
