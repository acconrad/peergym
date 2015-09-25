defmodule Peergym.PaymentTest do
  use Peergym.ModelCase

  alias Peergym.Payment

  @valid_attrs %{cc_number: 42, cvc: 42, month: 42, name: "some content", year: 42, zip: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Payment.changeset(%Payment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Payment.changeset(%Payment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
