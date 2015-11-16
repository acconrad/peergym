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

  def index(conn, %{"slug" => slug}) do
    slug_keywords = String.split(slug, "-")

    if List.last(slug_keywords) == "gyms" do
      query = filter_gyms(conn, slug_keywords)
      gyms = Repo.paginate(query)
      render conn, "landing-page.html",
        gyms: gyms.entries,
        page_number: gyms.page_number,
        total_pages: gyms.total_pages
    else
      redirect(to: gym_path(conn, :index))
    end
  end

  def index(conn, params) do
    delta = 0.0724146667
    if params["search"] do
      curr_lng = String.to_float(params["search"]["lng"])
      curr_lat = String.to_float(params["search"]["lat"])
      place = params["search"]["place"]
      city = params["search"]["city"]
      state = params["search"]["state"]
    else
      # TODO: geolocate to persons IP
      # Boston as the default
      curr_lat = 42.3600825
      curr_lng = -71.0588801
      place = "ChIJGzE9DS1l44kRoOhiASS_fHg"
      city = "Boston"
      state = "MA"
    end

    min_lng = curr_lng - delta
    max_lng = curr_lng + delta
    min_lat = curr_lat - delta
    max_lat = curr_lat + delta

    query = from g in Gym,
            where: g.latitude >= ^min_lat and g.latitude <= ^max_lat and g.longitude >= ^min_lng and g.longitude <= ^max_lng,
            select: g

    gyms = Repo.paginate(query)
    render conn, "index.html",
      gyms: gyms.entries,
      place: place,
      city: city,
      state: state,
      page_number: gyms.page_number,
      total_pages: gyms.total_pages
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

  def show(conn, %{"id" => slug}) do
    name_slug = slug
    |> String.replace("-", " ")

    query = from gym in Gym,
      where: fragment("lower(?)", gym.name) == ^name_slug,
      select: gym
    gym = Repo.one!(query)

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

  defp gyms_by_city(city) do
    from g in Gym,
      where: g.city == ^city,
      select: g
  end

  defp gyms_by_state(state) do
    from g in Gym,
      where: g.state == ^state,
      select: g
  end

  defp strongman_gyms do
    from g in Gym,
      where: g.atlas_stones > 1 or g.log_bars > 1 or g.kegs > 1,
      select: g
  end

  defp weightlifting_gyms do
    from g in Gym,
      where: g.platforms > 1 and g.jerk_blocks > 1 and g.bumper_plates > 1,
      select: g
  end

  defp powerlifting_gyms do
    from g in Gym,
      select: g
  end

  defp crossfit_gyms do
    from g in Gym,
      where: ilike(g.name, "crossfit%")
      select: g
  end

  defp gyms_by_type(type) do
    case type do
      "crossfit" -> crossfit_gyms
      "strongman" -> strongman_gyms
      "powerlifting" -> powerlifting_gyms
      "weightlifting" -> weightlifting_gyms
      "olympic-lifting" -> weightlifting_gyms
    end
  end

  defp filter_gyms(conn, slug_keywords) do
    # /TYPE-gyms
    # /STATE-gyms
    # /STATE-TYPE-gyms
    # /CITY-gyms
    # /CITY-TYPE-gyms
  end
end
