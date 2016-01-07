defmodule Peergym.Repo.Migrations.CreateGymEdit do
  use Ecto.Migration

  def change do
    create table(:gym_edits) do
      add :name, :string
      add :address, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :email, :string
      add :phone, :string
      add :url, :string
      add :description, :string
      add :hours, :string
      add :size, :integer
      add :coaches, :integer
      add :class_size, :integer
      add :day_rate, :float
      add :monthly_rate, :float
      add :annual_rate, :float
      add :is_owner, :boolean, default: false
      add :submitter_email, :string
      add :closed, :boolean, default: false
      add :gym_id, references(:gyms)

      timestamps
    end
    create index(:gym_edits, [:gym_id])

  end
end
