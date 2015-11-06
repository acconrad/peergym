defmodule Peergym.LayoutViewTest do
  use Peergym.ConnCase
  alias Peergym.User
  alias Passport.SessionManager
  import Passport.AuthenticationPlug

  setup do
    User.changeset(%User{}, %{password: "test", email: "test@test.com"})
    |> Repo.insert
    conn = conn()
    {:ok, conn: conn}
  end

  test "current user returns the user in the session", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: %{email: "test@test.com", password: "test"}
    assert SessionManager.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session" do
    user = Repo.get_by(User, %{email: "test@test.com"})
    conn = delete conn, session_path(conn, :delete, user)
    refute SessionManager.current_user(conn)
  end
end
