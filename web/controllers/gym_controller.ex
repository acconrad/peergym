defmodule Peergym.GymController do
  use Peergym.Web, :controller
  alias Peergym.Gym
  alias Peergym.Review
  import Passport.AuthenticationPlug

  plug PlugForwardedPeer
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
      conn
      |> redirect(to: gym_path(conn, :index))
    end
  end

  def index(conn, params) do
    delta = 0.1448293334

    if params["search"] do
      searched = true
      curr_lng = String.to_float(params["search"]["lng"])
      curr_lat = String.to_float(params["search"]["lat"])
      city = params["search"]["city"]
      state = params["search"]["state"]
    else
      searched = false
      record = Geolix.lookup(conn.remote_ip).city
      if record do
        curr_lat = record.location.latitude
        curr_lng = record.location.longitude

        if record.city do
          city = record.city.names.en
        else
          city = ""
        end

        if record.subdivisions do
          state_iso = record.subdivisions |> List.first
          state = state_iso.iso_code
        else
          state = record.country.names.en
        end
      else
        curr_lat = 42.3600825
        curr_lng = -71.0588801
        city = "Boston"
        state = "MA"
      end
    end

    curr_page = String.to_integer(params["page"] || "1")

    if state == "United States" do
      if params["order_by"] do
        query = from g in Gym,
          where: g.country == "US" and g.monthly_rate > 0 and (g.city == "New York" or g.city == "Los Angeles" or g.city == "Chicago" or g.city == "Houston" or g.city == "Philadelphia" or g.city == "Phoenix" or g.city == "San Francisco" or g.city == "Boston" or g.city == "Seattle" or g.city == "Las Vegas"),
          order_by: [g.monthly_rate],
          limit: 50,
          select: g
      else
        query = from g in Gym,
          where: g.country == "US" and (g.city == "New York" or g.city == "Los Angeles" or g.city == "Chicago" or g.city == "Houston" or g.city == "Philadelphia" or g.city == "Phoenix" or g.city == "San Francisco" or g.city == "Boston" or g.city == "Seattle" or g.city == "Las Vegas"),
          limit: 50,
          select: g
      end

      gym_blocks = Repo.all(query)
      |> Enum.map(&(Map.put(&1, :distance, 0)))
      |> Enum.chunk(10, 10, [])
    else
      min_lng = curr_lng - delta
      max_lng = curr_lng + delta
      min_lat = curr_lat - delta
      max_lat = curr_lat + delta

      if params["order_by"] do
        query = from g in Gym,
          where: g.monthly_rate > 0 and g.latitude >= ^min_lat and g.latitude <= ^max_lat and g.longitude >= ^min_lng and g.longitude <= ^max_lng,
          order_by: [g.monthly_rate],
          select: g

        gym_blocks = Repo.all(query)
        |> Enum.map(&(Map.put(&1, :distance, haversine_distance(&1, curr_lat, curr_lng) |> Float.round(1))))
        |> Enum.chunk(10, 10, [])
      else
        query = from g in Gym,
          where: g.latitude >= ^min_lat and g.latitude <= ^max_lat and g.longitude >= ^min_lng and g.longitude <= ^max_lng,
          select: g

        gym_blocks = Repo.all(query)
        |> Enum.sort(&(haversine_distance(&1, curr_lat, curr_lng) <= haversine_distance(&2, curr_lat, curr_lng)))
        |> Enum.map(&(Map.put(&1, :distance, haversine_distance(&1, curr_lat, curr_lng) |> Float.round(1))))
        |> Enum.chunk(10, 10, [])
      end
    end

    if gym_blocks |> Enum.any? do
      gyms = gym_blocks |> Enum.fetch!(curr_page - 1)
    end

    render conn, "index.html",
      gyms: gyms,
      city: city,
      state: state,
      lat: curr_lat,
      lng: curr_lng,
      page_number: curr_page,
      total_pages: gym_blocks |> Enum.count,
      searched: searched
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
    |> Repo.preload(:reviews)

    # photos = gym.photos
    # |> String.split(",")
    # |> Enum.map(&(Avatar.url({&1, gym}))

    review_query = from review in Review,
      where: review.gym_id == ^gym.id,
      select: count(review.id)

    reviews_count = Repo.one!(review_query)

    if gym do
      render(conn, "show.html", gym: gym, reviews_count: reviews_count)
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
    |> Repo.preload(:reviews)

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

  defp to_radians(degrees) do
    degrees * :math.pi/180.0
  end

  defp haversine_distance(gym, curr_lat, curr_lng) do
    lat1 = to_radians(gym.latitude)
    lon1 = to_radians(gym.longitude)
    lat2 = to_radians(curr_lat)
    lon2 = to_radians(curr_lng)

    dlat = lat2 - lat1
    dlon = lon2 - lon1

    a  = :math.pow(:math.sin(dlat/2),2) + :math.cos(lat1) * :math.cos(lat2) * :math.pow(:math.sin(dlon/2),2)
    c  = 2 * :math.atan2(:math.sqrt(a),:math.sqrt(1-a))
    c * 3961.0
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
      where: ilike(g.name, "crossfit%"),
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
