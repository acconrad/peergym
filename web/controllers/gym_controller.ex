defmodule Peergym.GymController do
  use Peergym.Web, :controller
  alias Peergym.Gym
  import Geo.PostGIS

  plug :scrub_params, "gym" when action in [:create, :update]

  def index(conn, params) do
    curr_lng = String.to_float(params["search"]["lng"])
    curr_lat = String.to_float(params["search"]["lat"])
    place = params["search"]["place"]
    point = %Geo.Point{ coordinates: { curr_lng, curr_lat }, srid: 4326 }

    query = from g in Gym,
            where: st_dwithin(g.geographic_point, ^point, 8046.7),
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
      Repo.insert(changeset)

      gym = Repo.get_by(Gym, google_place_id: gym_params["google_place_id"])
      new_point = %Geo.Point{ coordinates: { gym.longitude, gym.latitude }, srid: 4326 }

      from(g in Gym, where: g.id == ^gym.id, update: [set: [geographic_point: ^new_point]])
      |> Repo.update_all([])

      conn
      |> put_flash(:info, "Gym created successfully.")
      |> redirect(to: gym_path(conn, :edit, gym.id))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gym = Repo.get_by(Gym, place_id: id)

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
