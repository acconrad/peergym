defmodule Seeder do
  alias Peergym.Gym
  alias Peergym.Repo
  require IEx

  def create_gym(gym_params) do
    changeset = Gym.changeset(%Gym{}, gym_params)

    if changeset.valid? do
      Repo.insert!(changeset)
    end
  end

  def create_gyms(%{gyms: gyms_list}) do
    gyms_list
    |> Enum.each(&create_gym/1)

    IO.puts("Successfully seeded data!")
  end
end

# case File.read("data.json") do
#   {:ok, body}      -> Seeder.create_gyms(Poison.Parser.parse!(body, keys: :atoms!))
#   {:error, reason} -> IO.puts(reason)
# end

case File.read("crossfit.json") do
  {:ok, body}      -> Seeder.create_gyms(Poison.Parser.parse!(body, keys: :atoms!))
  {:error, reason} -> IO.puts(reason)
end
