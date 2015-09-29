defmodule Seeder do
  def create_gym(gym_params) do
    changeset = Peergym.Gym.changeset(%Peergym.Gym{}, gym_params)

    if changeset.valid? do
      Peergym.Repo.insert!(changeset)
    end
  end

  def create_gyms(%{gyms: gyms_list}) do
    gyms_list
    |> Enum.each(&create_gym/1)

    IO.puts("Successfully seeded data!")
  end
end

case File.read("data.json") do
  {:ok, body}      -> Seeder.create_gyms(Poison.Parser.parse!(body, keys: :atoms!))
  {:error, reason} -> IO.puts(reason)
end
