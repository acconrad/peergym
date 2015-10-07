defmodule Peergym.Repo.Migrations.UpdateUserToPassport do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :crypted_password, :string
      remove :username
      remove :hash
      remove :recovery_hash
    end
  end
end
