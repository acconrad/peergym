defmodule Peergym.GymTest do
  use Peergym.ModelCase

  alias Peergym.Gym
  import Ecto.Changeset, only: [get_change: 2]

  @valid_attrs %{
    "name" => "Gym",
    "address" => "1 Main St",
    "city" => "Springfield",
    "state" => "MA",
    "zip" => "01234",
    "country" => "US",
    "latitude" => 41.1,
    "longitude" => -71.1,
    "email" => "owner@gym.com",
    "phone" => "555-666-7777",
    "url" => "http://www.gym.com",
    "description" => "Some content",
    "hours" => "9a-5p",
    "google_place_id" => "abcdefg" }
  @invalid_attrs %{
    name: nil,
    address: nil,
    latitude: nil,
    longitude: nil
  }

  test "changeset with valid attributes" do
    changeset = Gym.changeset(%Gym{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Gym.changeset(%Gym{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "when the description includes a script tag" do
    changeset = Gym.changeset(%Gym{}, %{@valid_attrs | "description" => "Hello <script type='javascript'>alert('foo');</script>"})
    refute String.match? get_change(changeset, :description), ~r{<script>}
  end

  test "when the description includes an iframe tag" do
    changeset = Gym.changeset(%Gym{}, %{@valid_attrs | "description" => "Hello <iframe src='http://google.com'></iframe>"})
    refute String.match? get_change(changeset, :description), ~r{<iframe>}
  end

  test "description includes a link tag" do
    changeset = Gym.changeset(%Gym{}, %{@valid_attrs | "description" => "Hello <link>foo</link>"})
    assert String.match? get_change(changeset, :description), ~r{<link>}
  end

  test "description includes no stripped tags" do
    changeset = Gym.changeset(%Gym{}, @valid_attrs)
    assert get_change(changeset, :description) == @valid_attrs["description"]
  end
end
