defmodule Peergym.RegistrationController do
  use Peergym.Web, :controller
  alias Passport.RegistrationManager
  import Passport.AuthenticationPlug

  plug :action
  plug :require_logout, [
    flash_key: :info,
    flash_msg: "You're already logged in!",
    redirect_to: "/"
  ]

  def new(conn, _params) do
    conn
    |> put_session(:foo, "bar")
    |> render("new.html")
  end

  def create(conn, %{"registration" => registration_params}) do
    case RegistrationManager.register(registration_params) do
      {:ok, _changeset} -> conn
         |> put_flash(:info, "Registration success")
         |> redirect(to: page_path(conn, :index))
      _ -> conn
         |> put_flash(:error, "Registration failed")
         |> render("new.html")
    end
  end
end
