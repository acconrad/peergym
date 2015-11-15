defmodule Peergym.Repo.Migrations.AddRatesToGyms do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      add :day_rate, :float, default: 0.0
      add :monthly_rate, :float, default: 0.0
      add :annual_rate, :float, default: 0.0
    end
  end
end
