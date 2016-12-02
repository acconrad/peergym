defmodule Peergym.ReviewController do
  use Peergym.Web, :controller

  alias Peergym.Review

  plug :scrub_params, "review" when action in [:create, :update]
  plug :assign_gym
  plug :authorize_user when action in [:new, :create]
  plug :authorize_same_user when action in [:update, :edit, :delete]

  def new(conn, _params) do
    render(conn, "new.html", changeset: Review.changeset(%Review{}))
  end

  def create(conn, %{"review" => review_params}) do
    changeset = Review.changeset(review_params)

    case Repo.insert(changeset) do
      {:ok, _review} ->
        conn
        |> put_flash(:info, "Review created successfully.")
        |> redirect(to: gym_path(conn, :show, slug(conn.assigns[:gym])))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    review = Repo.get!(assoc(conn.assigns[:gym], :reviews), id)
    changeset = Review.changeset(review)
    render(conn, "edit.html", review: review, changeset: changeset)
  end

  def update(conn, %{"id" => id, "review" => review_params}) do
    review = Repo.get!(assoc(conn.assigns[:gym], :reviews), id)
    changeset = Review.changeset(review, review_params)

    case Repo.update(changeset) do
      {:ok, _review} ->
        conn
        |> put_flash(:info, "Review updated successfully.")
        |> redirect(to: gym_path(conn, :show, slug(conn.assigns[:gym])))
      {:error, changeset} ->
        render(conn, "edit.html", review: review, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    review = Repo.get!(assoc(conn.assigns[:gym], :reviews), id)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(review)
    conn
    |> put_flash(:info, "Review deleted successfully.")
    |> redirect(to: gym_path(conn, :show, slug(conn.assigns[:gym])))
  end

  defp assign_gym(conn, _) do
    %{"gym_id" => gym_id} = conn.params
    if gym = Repo.get(Peergym.Gym, gym_id) do
      assign(conn, :gym, gym)
    else
      conn
      |> put_flash(:error, "Invalid gym!")
      |> redirect(to: gym_path(conn, :index))
      |> halt()
    end
  end

  defp authorize_same_user(conn, _) do
    user = Repo.get(Peergym.User, get_session(conn, :current_user))

    if user && Integer.to_string(user.id) == conn.params["user_id"] do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that review!")
      |> redirect(to: gym_path(conn, :index))
      |> halt()
    end
  end

  defp authorize_user(conn, _) do
    if Repo.get(Peergym.User, get_session(conn, :current_user)) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to leave a review!")
      |> redirect(to: user_path(conn, :new))
      |> halt()
    end
  end

  defp slug(gym) do
    gym.name
    |> String.downcase
    |> String.replace(" ", "-")
  end
end
