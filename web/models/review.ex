defmodule Peergym.Review do
  use Peergym.Web, :model

  schema "reviews" do
    field :body, :string
    field :rating, :integer
    belongs_to :user, Peergym.User
    belongs_to :gym, Peergym.Gym

    timestamps
  end

  @required_fields ~w(body rating user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_length(:body, max: 1000)
  end
end
