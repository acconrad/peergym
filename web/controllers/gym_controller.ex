defmodule Peergym.GymController do
  use Peergym.Web, :controller
  alias Peergym.Gym
  alias Peergym.Navigation
  alias Peergym.Review
  import Passport.AuthenticationPlug

  plug PlugForwardedPeer
  plug :scrub_params, "gym" when action in [:create, :update]
  plug :require_admin, [
      flash_key: :info,
      flash_msg: "You do not have sufficient permissions to view this page.",
      redirect_to: "/"
    ] when action in [:new, :edit, :create, :update, :delete]

  ########## SEO landing pages ##########
  # def index(conn, %{"slug" => slug}) do
  #   slug_keywords = String.split(slug, "-")

  #   if List.last(slug_keywords) == "gyms" do
  #     gyms = Gym |> Gym.by_type(slug_keywords) |> Repo.paginate

  #     render conn, "landing-page.html",
  #       gyms: gyms.entries,
  #       page_number: gyms.page_number,
  #       total_pages: gyms.total_pages
  #   else
  #     conn
  #     |> redirect(to: gym_path(conn, :index))
  #   end
  # end
  def index(conn, %{"order_by" => order_by, "page" => page, "search" => location}) do
    page_number = String.to_integer(page)
    gyms_chunk = gym_chunks(location, order_by)

    render conn, "index.html",
      gyms: gyms_chunk |> Enum.fetch!(page_number - 1),
      location: location,
      page_count: gyms_chunk |> Enum.count,
      page_number: page_number
  end
  def index(conn, %{"page" => page, "search" => location}) do
    page_number = String.to_integer(page)
    gyms_chunk = gym_chunks(location, nil)

    render conn, "index.html",
      gyms: gyms_chunk |> Enum.fetch!(page_number - 1),
      location: location,
      page_count: gyms_chunk |> Enum.count,
      page_number: page_number
  end
  def index(conn, _params) do
    location = Navigation.find_location(conn.remote_ip)
    gyms_chunk = gym_chunks(location, nil)

    render conn, "index.html",
      gyms: gyms_chunk |> Enum.fetch!(0),
      location: location,
      page_count: gyms_chunk |> Enum.count,
      page_number: 1
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: Gym.changeset(%Gym{}))
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
    gym =
      Gym
      |> Gym.by_slug(slug |> String.replace("-", " "))
      |> Repo.one!
      |> Repo.preload(:reviews)

    if gym do
      render(conn, "show.html", gym: gym, reviews_count: Review |> Review.count(gym) |> Repo.one!)
    else
      conn
      |> redirect(to: gym_path(conn, :new, name: conn.query_string))
    end
  end

  def edit(conn, %{"id" => id}) do
    gym = Repo.get(Gym, id)
    render(conn, "edit.html", gym: gym, changeset: Gym.changeset(gym))
  end

  def update(conn, %{"id" => id, "gym" => gym_params}) do
    gym = Gym |> Repo.get(id) |> Repo.preload(:reviews)
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
    Repo.delete(Repo.get(Gym, id))

    conn
    |> put_flash(:info, "Gym deleted successfully.")
    |> redirect(to: gym_path(conn, :index))
  end

  defp gym_chunks(location, ordered) do
    if location["state"] == "United States" do
      Gym
      |> Gym.in_major_us_cities(ordered)
      |> Repo.all
      |> Enum.map(&(Map.put(&1, :distance, 0)))
      |> Enum.chunk(10, 10, [])
    else
      Gym
      |> Gym.within_bounding_box(location, ordered)
      |> Repo.all
      |> Enum.sort(&(Navigation.haversine(&1, location) <= Navigation.haversine(&2, location)))
      |> Enum.map(&(Map.put(&1, :distance, Float.round(Navigation.haversine(&1, location), 1))))
      |> Enum.chunk(10, 10, [])
    end
  end
end
