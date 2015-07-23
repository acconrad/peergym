defmodule Peergym.GymControllerTest do
  use Peergym.ConnCase

  alias Peergym.Gym
  @valid_attrs %{basketball: true, bicycle: true, classes: true, description: "some content", dumbbells_up_to: 42, elliptical: true, free_weights: true, machines: true, name: "some content", personal_training: true, pool: true, powerlifting: true, squash: true, stepper: true, strongman: true, treadmill: true, trx: true, weightlifting: true}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, gym_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing gyms"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, gym_path(conn, :new)
    assert html_response(conn, 200) =~ "New gym"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, gym_path(conn, :create), gym: @valid_attrs
    assert redirected_to(conn) == gym_path(conn, :index)
    assert Repo.get_by(Gym, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, gym_path(conn, :create), gym: @invalid_attrs
    assert html_response(conn, 200) =~ "New gym"
  end

  test "shows chosen resource", %{conn: conn} do
    gym = Repo.insert %Gym{}
    conn = get conn, gym_path(conn, :show, gym)
    assert html_response(conn, 200) =~ "Show gym"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    gym = Repo.insert %Gym{}
    conn = get conn, gym_path(conn, :edit, gym)
    assert html_response(conn, 200) =~ "Edit gym"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    gym = Repo.insert %Gym{}
    conn = put conn, gym_path(conn, :update, gym), gym: @valid_attrs
    assert redirected_to(conn) == gym_path(conn, :index)
    assert Repo.get_by(Gym, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    gym = Repo.insert %Gym{}
    conn = put conn, gym_path(conn, :update, gym), gym: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit gym"
  end

  test "deletes chosen resource", %{conn: conn} do
    gym = Repo.insert %Gym{}
    conn = delete conn, gym_path(conn, :delete, gym)
    assert redirected_to(conn) == gym_path(conn, :index)
    refute Repo.get(Gym, gym.id)
  end
end
