defmodule Peergym.GymController do
  use Peergym.Web, :controller
  alias Peergym.Gym

  plug :scrub_params, "gym" when action in [:create, :update]

  def index(conn, params) do
    place = params["search"]["place"]
    render(conn, "index.html", place: place)
  end

  def new(conn, _params) do
    changeset = Gym.changeset(%Gym{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"gym" => gym_params}) do
    changeset = Gym.changeset(%Gym{}, gym_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Gym created successfully.")
      |> redirect(to: gym_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gym = Repo.get(Gym, id)
    render(conn, "show.html", gym: gym)
  end

  def edit(conn, %{"id" => id}) do
    gym = Repo.get(Gym, id)
    changeset = Gym.changeset(gym)
    render(conn, "edit.html", gym: gym, changeset: changeset)
  end

  def update(conn, %{"id" => id, "gym" => gym_params}) do
    gym = Repo.get(Gym, id)
    changeset = Gym.changeset(gym, gym_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Gym updated successfully.")
      |> redirect(to: gym_path(conn, :index))
    else
      render(conn, "edit.html", gym: gym, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gym = Repo.get(Gym, id)
    Repo.delete(gym)

    conn
    |> put_flash(:info, "Gym deleted successfully.")
    |> redirect(to: gym_path(conn, :index))
  end
end
