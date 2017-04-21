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

  @doc """
  Creates a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :cc_number, :month, :year, :cvc, :zip])
  end
end
