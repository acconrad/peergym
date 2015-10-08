defmodule Peergym.RegistrationController do
  use Peergym.Web, :controller
  alias Peergym.User
  import Passport.AuthenticationPlug

  plug :action
  plug :require_logout, [
    flash_key: :info,
    flash_msg: "You're already logged in!",
    redirect_to: "/"
  ]

  def new(conn, _params) do
    conn
    |> render("new.html")
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "User created successfully.")
      |> redirect(to: page_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end
end
