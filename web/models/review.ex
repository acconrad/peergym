defmodule Peergym.Review do
  @moduledoc """
  A module for writing user reviews about the gyms.
  """

  use Peergym.Web, :model

  schema "reviews" do
    field :body, :string
    field :rating, :integer
    belongs_to :user, Peergym.User
    belongs_to :gym, Peergym.Gym

    timestamps()
  end

  @doc """
  Creates a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :rating, :user_id])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_length(:body, max: 1000)
  end

  def count(query, gym) do
    from r in query,
    where: r.gym_id == ^gym.id,
    select: count(r.id)
  end
end
