defmodule Peergym.GymEditTest do
  use Peergym.ModelCase

  alias Peergym.GymEdit

  @valid_attrs %{address: "some content", annual_rate: "120.5", city: "some content", class_size: 42, closed: true, coaches: 42, day_rate: "120.5", description: "some content", email: "some content", hours: "some content", is_owner: true, monthly_rate: "120.5", name: "some content", phone: "some content", size: 42, state: "some content", submitter_email: "some content", url: "some content", zip: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GymEdit.changeset(%GymEdit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GymEdit.changeset(%GymEdit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
