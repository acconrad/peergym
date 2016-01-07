defmodule Peergym.GymEditController do
  use Peergym.Web, :controller

  alias Peergym.GymEdit

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

  def new(conn, _params) do
    changeset = GymEdit.changeset(%GymEdit{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"gym_edit" => gym_edit_params}) do
    changeset = GymEdit.changeset(%GymEdit{}, gym_edit_params)

    case Repo.insert(changeset) do
      {:ok, _gym_edit} ->
        conn
        |> put_flash(:info, "Gym edit created successfully.")
        |> redirect(to: gym_edit_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    gym_edit = Repo.get!(GymEdit, id)
    changeset = GymEdit.changeset(gym_edit)
    render(conn, "edit.html", gym_edit: gym_edit, changeset: changeset)
  end

  def update(conn, %{"id" => id, "gym_edit" => gym_edit_params}) do
    gym_edit = Repo.get!(GymEdit, id)
    changeset = GymEdit.changeset(gym_edit, gym_edit_params)

    case Repo.update(changeset) do
      {:ok, gym_edit} ->
        conn
        |> put_flash(:info, "Gym edit updated successfully.")
        |> redirect(to: gym_edit_path(conn, :show, gym_edit))
      {:error, changeset} ->
        render(conn, "edit.html", gym_edit: gym_edit, changeset: changeset)
    end
  end
end
