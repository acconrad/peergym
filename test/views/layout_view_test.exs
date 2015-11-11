defmodule Peergym.LayoutViewTest do
  use Peergym.ConnCase
  alias Peergym.User
  alias Passport.SessionManager

  @valid_attrs %{email: "person@example.com", password: "test1234"}

  setup do
    Peergym.Registration.create(User.changeset(%User{}, @valid_attrs), Peergym.Repo)
    conn = conn()
    {:ok, conn: conn}
  end

  test "current user returns the user only when a session exists", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: %{"email": "person@example.com", "password": "test1234"}
    assert SessionManager.current_user(conn)

    conn = get conn, session_path(conn, :delete)
    refute SessionManager.current_user(conn)
  end
end
