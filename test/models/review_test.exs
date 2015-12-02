defmodule Peergym.ReviewTest do
  use Peergym.ModelCase

  alias Peergym.Review

  @valid_attrs %{body: "some content", rating: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Review.changeset(%Review{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Review.changeset(%Review{}, @invalid_attrs)
    refute changeset.valid?
  end
end
