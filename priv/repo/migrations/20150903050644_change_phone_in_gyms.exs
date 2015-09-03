defmodule Peergym.Repo.Migrations.ChangePhoneInGyms do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      remove :phone_number
      add :phone, :string
    end
  end
end
