defmodule Peergym.GymEditController do
  use Peergym.Web, :controller
  alias Peergym.GymEdit
  alias Peergym.Gym
  import Passport.AuthenticationPlug

  plug :scrub_params, "gym_edit" when action in [:create, :update]
  plug :require_admin, [
      flash_key: :info,
      flash_msg: "You do not have sufficient permissions to view this page.",
      redirect_to: "/"
    ] when action in [:index, :edit, :update]

  def index(conn, _params) do
    gym_edits = Repo.all(GymEdit)
    render(conn, "index.html", gym_edits: gym_edits)
  end

  def new(conn, params) do
    changeset = GymEdit.changeset(%GymEdit{})

    if params["gym_id"] do
      render(conn, "new.html", changeset: changeset, gym: Repo.get(Gym, params["gym_id"]))
    else
      render(conn, "new.html", changeset: changeset, gym: %Gym{})
    end
  end

  def create(conn, %{"gym_edit" => gym_edit_params}) do
    changeset = GymEdit.changeset(%GymEdit{}, gym_edit_params)

    case Repo.insert(changeset) do
      {:ok, _gym_edit} ->
        conn
        |> put_flash(:info, "Thank you for your contribution! We'll verify this with our staff.")
        |> redirect(to: gym_edit_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    gym_edit = Repo.get!(GymEdit, id)

    gym =
      if gym_edit.gym_id do
        Repo.get(Gym, gym_edit.gym_id)
      else
        %Gym{}
      end

    changeset = GymEdit.changeset(gym_edit)
    render(conn, "edit.html", gym_edit: gym_edit, gym: gym, changeset: changeset)
  end

  def update(conn, %{"id" => id, "gym_edit" => gym_edit_params}) do
    gym_edit = Repo.get!(GymEdit, id)

    gym = Gym
    |> Repo.get!(gym_edit_params["gym_id"])
    |> Repo.preload(:reviews)

    changeset = Gym.changeset(gym, gym_edit_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Gym updated!")
        |> redirect(to: gym_edit_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", gym_edit: gym_edit, changeset: changeset)
    end
  end
end
