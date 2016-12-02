defmodule Peergym.SessionControllerTest do
  use Peergym.ConnCase

  setup do
    changeset = Peergym.User.changeset(%Peergym.User{}, %{password: "test1234", email: "test@test.com"})
    Peergym.Registration.create(changeset, Peergym.Repo)
    conn = build_conn()
    {:ok, conn: conn}
  end

  test "shows the login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Log In"
  end

  test "creates a new user session for a valid user", %{conn: conn} do
    valid_attrs = %{"email" => "test@test.com", "password" => "test1234"}
    conn = post conn, session_path(conn, :create), session: valid_attrs
    assert get_flash(conn, :info) == "All signed in!"
    assert redirected_to(conn) == gym_path(conn, :index)
  end

  test "does not create a session with a bad login", %{conn: conn} do
    wrong_password_attrs = %{"email" => "test@test.com", "password" => "wrong"}
    conn = post conn, session_path(conn, :create), session: wrong_password_attrs
    assert get_flash(conn, :error) == "Email or password incorrect."
    assert html_response(conn, 200) =~ "Log In"
  end

  test "does not create a session if user does not exist", %{conn: conn} do
    invalid_attrs = %{"email" => "foo@example.com", "password" => "wrong"}
    conn = post conn, session_path(conn, :create), session: invalid_attrs
    assert get_flash(conn, :error) == "Email or password incorrect."
    assert html_response(conn, 200) =~ "Log In"
  end

  test "warns you if you try to sign in when already signed in" do
    valid_attrs = %{"email" => "test@test.com", "password" => "test1234"}
    conn = post conn, session_path(conn, :create), session: valid_attrs
    conn = post conn, session_path(conn, :create), session: valid_attrs
    assert get_flash(conn, :info) == "You're already logged in!"
    assert redirected_to(conn) == gym_path(conn, :index)
  end

  test "deletes the user session if it exists", %{conn: conn} do
    conn = get conn, session_path(conn, :delete)
    assert get_flash(conn, :info) == "Signed out succesfully."
    assert redirected_to(conn) == gym_path(conn, :index)
  end
end
