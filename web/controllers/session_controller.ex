defmodule Peergym.SessionController do
  use Peergym.Web, :controller
  alias Passport.SessionManager
  import Passport.AuthenticationPlug

  plug :action
  plug :require_logout, [
      flash_key: :info,
      flash_msg: "You're already logged in!",
      redirect_to: "/"
    ]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case SessionManager.login(conn, session_params) do
      {:ok, conn, _user} -> conn
        |> put_flash(:info, "All signed in!")
        |> redirect(to: page_path(conn, :index))
      {:error, conn} -> conn
        |> put_flash(:error, "Email or password incorrect.")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    SessionManager.logout(conn)
    |> put_flash(:info, "Signed out succesfully.")
    |> redirect(to: page_path(conn, :index))
  end
end
