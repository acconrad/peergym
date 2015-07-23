defmodule Peergym.GymTest do
  use Peergym.ModelCase

  alias Peergym.Gym

  @valid_attrs %{basketball: true, bicycle: true, classes: true, description: "some content", dumbbells_up_to: 42, elliptical: true, free_weights: true, machines: true, name: "some content", personal_training: true, pool: true, powerlifting: true, squash: true, stepper: true, strongman: true, treadmill: true, trx: true, weightlifting: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Gym.changeset(%Gym{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Gym.changeset(%Gym{}, @invalid_attrs)
    refute changeset.valid?
  end
end
