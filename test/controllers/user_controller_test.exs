defmodule Peergym.UserControllerTest do
  use Peergym.ConnCase

  alias Peergym.User
  @valid_create_attrs %{email: "test@example.com", password: "test1234"}
  @valid_attrs %{email: "test@example.com"}
  @invalid_attrs %{email: "thing"}

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_create_attrs
    assert redirected_to(conn) == gym_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "User"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: logged_in_user
    user = Repo.get_by(User, %{email: "test@test.com"})
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: logged_in_user
    user = Repo.get_by(User, %{email: "test@test.com"})
    conn = put conn, user_path(conn, :update, user), user: %{email: "test@example.com", password: "test2345", admin: true}
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: logged_in_user
    user = Repo.get_by(User, %{email: "test@test.com"})
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit"
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: logged_in_user
    user = Repo.get_by(User, %{email: "test@test.com"})
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == gym_path(conn, :index)
    refute Repo.get(User, user.id)
  end

  def logged_in_user do
    Peergym.Registration.create(User.changeset(%User{}, %{
      password: "test1234",
      email: "test@test.com"}), Peergym.Repo)
    %{"email" => "test@test.com", "password" => "test1234"}
  end
end
