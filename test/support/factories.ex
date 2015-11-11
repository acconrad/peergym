defmodule Peergym.Factory do
  use ExMachina.Ecto, repo: Peergym.Repo
  alias Peergym.Gym
  alias Peergym.Payment
  alias Peergym.User

  def factory(:user, _attrs) do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "test1234"
    }
  end

  def factory(:admin_user, _attrs) do
    %User{
      email: sequence(:email, &"admin-#{&1}@example.com"),
      password: "test1234",
      admin: true
    }
  end

  def factory(:gym, _attrs) do
    %Gym{
      name: "Gym",
      address: "1 Main St",
      city: "Springfield",
      state: "MA",
      zip: "01234",
      country: "US",
      latitude: 41.1,
      longitude: -71.1,
      email: sequence(:email, &"gym-#{&1}@example.com"),
      phone: "555-666-7777",
      url: "http://www.gym.com",
      description: "Some content",
      hours: "9a-5p",
      google_place_id: "abcdefg"
    }
  end

  def factory(:payment, _attrs) do
    %Payment{
      name: "Test User",
      cc_number: 1234,
      month: 11,
      year: 2020,
      cvc: 111,
      zip: 01234
    }
  end
end
