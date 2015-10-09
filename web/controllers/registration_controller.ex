defmodule Peergym.RegistrationController do
  use Peergym.Web, :controller
  alias Peergym.User
  import Passport.AuthenticationPlug

  plug :scrub_params, "user" when action in [:create]
  plug :require_logout, [
    flash_key: :info,
    flash_msg: "You're already logged in!",
    redirect_to: "/"
  ]

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    if changeset.valid? do
      Peergym.Registration.create(changeset, Peergym.Repo)

      conn
      |> put_flash(:info, "Your account was created!")
      |> redirect(to: page_path(conn, :index))
    else
      conn
      |> put_flash(:info, "Oh no, we ran into a problem!")
      |> render("new.html", changeset: changeset)
    end
  end
end
