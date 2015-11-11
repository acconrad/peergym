defmodule Peergym.GymControllerTest do
  use Peergym.ConnCase

  alias Peergym.Gym
  alias Peergym.User

  @valid_attrs %{
    name: "Gym",
    address: "1 Main St",
    city: "Springfield",
    state: "MA",
    zip: "01234",
    country: "US",
    latitude: 41.1,
    longitude: -71.1,
    email: "owner@gym.com",
    phone: "555-666-7777",
    url: "http://www.gym.com",
    description: "Some content",
    hours: "9a-5p",
    google_place_id: "abcdefg" }
  @invalid_attrs %{latitude: "abc"}

  setup do
    conn = conn()
  {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, gym_path(conn, :index)
    assert html_response(conn, 200) =~ "gyms-list"
  end

  test "redirects away from creating new gyms unless you are an admin", %{conn: conn} do
    conn = get conn, gym_path(conn, :new)
    assert redirected_to(conn) == gym_path(conn, :index)
  end

  test "shows the form for a new gym if you are an admin", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: admin_user
    conn = get conn, gym_path(conn, :new)
    assert html_response(conn, 200) =~ "Add a Gym"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: admin_user
    conn = post conn, gym_path(conn, :create), gym: @valid_attrs
    gym = Repo.get_by(Gym, @valid_attrs)
    assert redirected_to(conn) == gym_path(conn, :edit, gym.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: admin_user
    conn = post conn, gym_path(conn, :create), gym: @invalid_attrs
    assert html_response(conn, 200) =~ "Add a Gym"
  end

  test "shows chosen resource", %{conn: conn} do
    gym = create(:gym)
    conn = get conn, gym_path(conn, :show, gym)
    assert html_response(conn, 200) =~ gym.name
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: admin_user
    gym = create(:gym)
    conn = get conn, gym_path(conn, :edit, gym)
    assert html_response(conn, 200) =~ "Edit your gym"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: admin_user
    gym = create(:gym)
    conn = put conn, gym_path(conn, :update, gym), gym: @valid_attrs
    assert redirected_to(conn) == gym_path(conn, :edit, gym.id)
    assert Repo.get_by(Gym, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: admin_user
    gym = create(:gym)
    conn = put conn, gym_path(conn, :update, gym), gym: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit your gym"
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: admin_user
    gym = create(:gym)
    conn = delete conn, gym_path(conn, :delete, gym)
    assert redirected_to(conn) == gym_path(conn, :index)
    refute Repo.get(Gym, gym.id)
  end

  def admin_user do
    {:ok, user} = Peergym.Registration.create(User.changeset(%User{}, %{
      password: "test1234",
      email: "test@test.com"}), Peergym.Repo)
    Repo.update(User.changeset(user, %{admin: true}))
    %{"email" => "test@test.com", "password" => "test1234"}
  end
end
