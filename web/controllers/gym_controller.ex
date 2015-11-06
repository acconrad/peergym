defmodule Peergym.GymController do
  use Peergym.Web, :controller
  alias Peergym.Gym
  import Passport.AuthenticationPlug

  plug :scrub_params, "gym" when action in [:create, :update]
  plug :require_admin, [
      flash_key: :info,
      flash_msg: "You do not have sufficient permissions to view this page.",
      redirect_to: "/"
    ] when action in [:new, :edit, :create, :update, :delete]

  def index(conn, params) do
    delta = 0.0724146667
    if params["search"] do
      curr_lng = String.to_float(params["search"]["lng"])
      curr_lat = String.to_float(params["search"]["lat"])
      place = params["search"]["place"]
    else
      # New York City as the default
      curr_lat = 40.7029741
      curr_lng = -74.2598655
    end

    min_lng = curr_lng - delta
    max_lng = curr_lng + delta
    min_lat = curr_lat - delta
    max_lat = curr_lat + delta

    query = from g in Gym,
            where: g.latitude >= ^min_lat and g.latitude <= ^max_lat and g.longitude >= ^min_lng and g.longitude <= ^max_lng,
            select: g

    gyms = Repo.all(query)
    render(conn, "index.html", gyms: gyms, place: place)
  end

  def new(conn, _params) do
    changeset = Gym.changeset(%Gym{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"gym" => gym_params}) do
    changeset = Gym.changeset(%Gym{}, gym_params)

    if changeset.valid? do
      {:ok, new_gym} = Repo.insert(changeset)

      conn
      |> put_flash(:info, "Gym created successfully.")
      |> redirect(to: gym_path(conn, :edit, new_gym.id))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gym = Repo.get(Gym, id)

    if gym do
      render(conn, "show.html", gym: gym)
    else
      conn
      |> redirect(to: gym_path(conn, :new, name: conn.query_string))
    end
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
      |> redirect(to: gym_path(conn, :edit, id))
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
