defmodule Peergym.Review do
  use Peergym.Web, :model

  schema "reviews" do
    field :body, :string
    field :rating, :integer
    belongs_to :user, Peergym.User
    belongs_to :gym, Peergym.Gym

    timestamps
  end

  @required_fields ~w(body rating)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
