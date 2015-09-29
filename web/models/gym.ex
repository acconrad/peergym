defmodule Peergym.Gym do
  use Peergym.Web, :model

  schema "gyms" do
    field :name, :string
    field :address, :string
    field :street, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :country, :string
    field :latitude, :float
    field :longitude, :float
    field :email, :string
    field :phone, :string
    field :url, :string
    field :description, :string
    field :hours, :string
    field :google_place_id, :string

    timestamps
  end

  @required_fields ~w(name address latitude longitude)
  @optional_fields ~w(street city state zip country email phone url description hours google_place_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    # |> unique_constraint(:google_place_id)
  end
end
