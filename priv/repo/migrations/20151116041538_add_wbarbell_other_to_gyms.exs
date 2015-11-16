defmodule Peergym.Repo.Migrations.AddWbarbellOtherToGyms do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      add :womens_barbells, :integer
      add :other, :string
    end
  end
end
