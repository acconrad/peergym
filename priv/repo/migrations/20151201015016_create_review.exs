defmodule Peergym.Repo.Migrations.CreateReview do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :body, :text
      add :rating, :integer
      add :user_id, references(:users)
      add :gym_id, references(:gyms)

      timestamps
    end
    create index(:reviews, [:user_id])
    create index(:reviews, [:gym_id])

  end
end
