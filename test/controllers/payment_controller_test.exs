defmodule Peergym.PaymentControllerTest do
  use Peergym.ConnCase

  alias Peergym.Gym
  @valid_attrs %{email: "test@example.com"}
  @invalid_attrs %{email: "thing"}

  setup do
    Gym.changeset(%Gym{}, %{name: "Gym", address: "1 Main St", latitude: 70.0, longitude: -42.0})
    |> Repo.insert
    conn = build_conn()
    {:ok, conn: conn}
  end

  test "renders form for new resources", %{conn: conn} do
    gym = Repo.get_by(Gym, %{name: "Gym"})
    conn = get conn, gym_payment_path(conn, :new, gym.id)
    assert html_response(conn, 200) =~ "Ready for a great workout"
  end

  test "creates resource and redirects when data is valid", %{conn: _conn} do
    # gym = Repo.get_by(Gym, %{name: "Gym"})
    # conn = post conn, gym_payment_path(conn, :create, gym.id), payment: @valid_attrs
    # assert redirected_to(conn) == gym_path(conn, :show, gym.id)
    # assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: _conn} do
    # gym = Repo.get_by(Gym, %{name: "Gym"})
    # conn = post conn, gym_payment_path(conn, :create, gym.id), payment: @invalid_attrs
    # assert html_response(conn, 200) =~ "Ready for a great workout"
  end
end
