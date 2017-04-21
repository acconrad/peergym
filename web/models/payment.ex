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

    timestamps()
  end

  @fields ~w(name cc_number month year cvc zip)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
  end
end
