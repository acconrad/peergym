defmodule Peergym.Repo.Migrations.CleanUpGyms do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      remove :treadmill
      remove :bicycle
      remove :stepper
      remove :elliptical
      remove :free_weights
      remove :machines
      remove :trx
      remove :pool
      remove :classes
      remove :personal_training
      remove :dumbbells_up_to
      remove :powerlifting
      remove :weightlifting
      remove :strongman
      remove :basketball
      remove :squash
      add :street, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :country, :string
      add :email, :string
      add :url, :string
      add :description, :string
    end
  end
end
