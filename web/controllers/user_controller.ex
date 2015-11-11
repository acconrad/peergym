defmodule Peergym.UserController do
  use Peergym.Web, :controller
  alias Peergym.User
  import Passport.AuthenticationPlug

  plug :scrub_params, "user" when action in [:create, :update]
  plug :require_login, [
    flash_key: :info,
    flash_msg: "You must be logged in to continue.",
    redirect_to: "/signin"
  ] when action in [:edit, :update, :delete]
  plug :require_logout, [
    flash_key: :info,
    flash_msg: "You're already logged in!",
    redirect_to: "/"
  ] when action in [:new, :create]

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
      |> redirect(to: gym_path(conn, :index))
    else
      conn
      |> put_flash(:info, "Oh no, we ran into a problem!")
      |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    if user do
      render(conn, "show.html", user: user)
    else
      conn
      |> redirect(to: user_path(conn, :new, name: conn.query_string))
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "User updated successfully.")
      |> redirect(to: user_path(conn, :show, id))
    else
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Repo.delete(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: gym_path(conn, :index))
  end

end
