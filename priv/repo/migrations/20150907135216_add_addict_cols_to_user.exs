defmodule Peergym.Repo.Migrations.AddAddictColsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
      add :hash, :string
      add :recovery_hash, :string
      add :admin, :boolean, default: false
    end
  end
end
