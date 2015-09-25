defmodule Peergym.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :name, :string
      add :cc_number, :integer
      add :month, :integer
      add :year, :integer
      add :cvc, :integer
      add :zip, :integer

      timestamps
    end

  end
end
