defmodule Peergym.GymController do
  use Peergym.Web, :controller
  alias Peergym.Gym
  alias Peergym.Navigation
  alias Peergym.Review
  import Passport.AuthenticationPlug
  require IEx

  plug PlugForwardedPeer
  plug :scrub_params, "gym" when action in [:create, :update]
  plug :require_admin, [
      flash_key: :info,
      flash_msg: "You do not have sufficient permissions to view this page.",
      redirect_to: "/"
    ] when action in [:new, :edit, :create, :update, :delete]

  def index(conn, %{"page" => page, "order_by" => order_by, "search" => location}) do
    page_number = page |> String.to_integer
    gyms_chunk = gym_chunks(location, order_by)
    gyms = fetch_gyms(gyms_chunk, page_number)

    render conn, "index.html",
      gyms: gyms,
      location: location,
      page_count: gyms_chunk |> Enum.count,
      page_number: page_number
  end
  def index(conn, %{"page" => page, "search" => location}) do
    page_number = page |> String.to_integer
    gyms_chunk = gym_chunks(location)
    gyms = fetch_gyms(gyms_chunk, page_number)

    render conn, "index.html",
      gyms: gyms,
      location: location,
      page_count: gyms_chunk |> Enum.count,
      page_number: page_number
  end
  def index(conn, %{"search" => location}) do
    gyms_chunk = gym_chunks(location)
    gyms = fetch_gyms(gyms_chunk, 1)

    render conn, "index.html",
      gyms: gyms,
      location: location,
      page_count: gyms_chunk |> Enum.count,
      page_number: 1
  end
  def index(conn, _params) do
    location = Navigation.find_location(conn.remote_ip)
    gyms_chunk = gym_chunks(location)
    gyms = fetch_gyms(gyms_chunk, 0)

    render conn, "index.html",
      gyms: gyms,
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

  defp fetch_gyms(pages, index) do
    case pages |> Enum.fetch(index - 1) do
      {:ok, gyms} -> gyms
      :error      -> nil
    end
  end

  defp gym_chunks(location, ordered) do
    if location["location"] == "United States" do
      Gym
      |> Gym.in_major_us_cities(ordered)
      |> Repo.all
      |> Enum.map(&(Map.put(&1, :distance, 0)))
      |> Enum.chunk(10, 10, [])
    else
      Gym
      |> Gym.within_bounding_box(location, (if location["city"] == "", do: 10, else: 1), ordered)
      |> Repo.all
      |> Enum.sort(&(Navigation.haversine(&1, location) <= Navigation.haversine(&2, location)))
      |> Enum.map(&(Map.put(&1, :distance, Float.round(Navigation.haversine(&1, location), 1))))
      |> Enum.chunk(10, 10, [])
    end
  end
  defp gym_chunks(location) do
    IEx.pry
    if location["location"] == "United States" do
      Gym
      |> Gym.in_major_us_cities
      |> Repo.all
      |> Enum.map(&(Map.put(&1, :distance, 0)))
      |> Enum.chunk(10, 10, [])
    else
      Gym
      |> Gym.within_bounding_box(location, (if location["city"] == "", do: 10, else: 1))
      |> Repo.all
      |> Enum.sort(&(Navigation.haversine(&1, location) <= Navigation.haversine(&2, location)))
      |> Enum.map(&(Map.put(&1, :distance, Float.round(Navigation.haversine(&1, location), 1))))
      |> Enum.chunk(10, 10, [])
    end
  end
end
