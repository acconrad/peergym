defmodule Peergym.Repo.Migrations.CreateGym do
  use Ecto.Migration

  def change do
    create table(:gyms) do
      add :name, :string
      add :description, :string
      add :treadmill, :boolean, default: false
      add :bicycle, :boolean, default: false
      add :stepper, :boolean, default: false
      add :elliptical, :boolean, default: false
      add :free_weights, :boolean, default: false
      add :machines, :boolean, default: false
      add :trx, :boolean, default: false
      add :pool, :boolean, default: false
      add :classes, :boolean, default: false
      add :personal_training, :boolean, default: false
      add :dumbbells_up_to, :integer
      add :powerlifting, :boolean, default: false
      add :weightlifting, :boolean, default: false
      add :strongman, :boolean, default: false
      add :basketball, :boolean, default: false
      add :squash, :boolean, default: false

      timestamps
    end

  end
end
