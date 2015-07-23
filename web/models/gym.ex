defmodule Peergym.Gym do
  use Peergym.Web, :model

  schema "gyms" do
    field :name, :string
    field :description, :string
    field :treadmill, :boolean, default: false
    field :bicycle, :boolean, default: false
    field :stepper, :boolean, default: false
    field :elliptical, :boolean, default: false
    field :free_weights, :boolean, default: false
    field :machines, :boolean, default: false
    field :trx, :boolean, default: false
    field :pool, :boolean, default: false
    field :classes, :boolean, default: false
    field :personal_training, :boolean, default: false
    field :dumbbells_up_to, :integer
    field :powerlifting, :boolean, default: false
    field :weightlifting, :boolean, default: false
    field :strongman, :boolean, default: false
    field :basketball, :boolean, default: false
    field :squash, :boolean, default: false

    timestamps
  end

  @required_fields ~w(name description treadmill bicycle stepper elliptical free_weights machines trx pool classes personal_training dumbbells_up_to powerlifting weightlifting strongman basketball squash)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
