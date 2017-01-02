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

    timestamps
  end

  @fields ~w(body rating user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_length(:body, max: 1000)
  end

  def count(query, gym) do
    from r in query,
    where: r.gym_id == ^gym.id,
    select: count(r.id)
  end
end
