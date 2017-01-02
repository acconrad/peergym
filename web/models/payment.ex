defmodule Peergym.Payment do
  @moduledoc """
  A tentative module for storing payment information.
  TODO: use Stripe to handle this, this is probably not secure.
  """

  use Peergym.Web, :model

  schema "payments" do
    field :name, :string
    field :cc_number, :integer
    field :month, :integer
    field :year, :integer
    field :cvc, :integer
    field :zip, :integer

    timestamps
  end

  @required_fields ~w(name cc_number month year cvc zip)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
