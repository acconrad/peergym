defmodule Peergym.PaymentController do
  use Peergym.Web, :controller

  alias Peergym.Payment
  alias Peergym.Gym
  alias Peergym.User

  plug :scrub_params, "payment" when action in [:create, :update]

  def new(conn, params) do
    changeset = Payment.changeset(%Payment{})
    gym = Repo.get!(Gym, params["gym_id"])
    render(conn, "new.html", changeset: changeset, gym: gym)
  end

  def create(conn, %{"payment" => payment_params, "gym_id" => id}) do
    changeset = User.changeset(%User{}, payment_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Thanks! We'll contact your gym right away so you can get your flex on.")
      |> redirect(to: gym_path(conn, :show, id))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Repo.get!(Payment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(payment)

    conn
    |> put_flash(:info, "Payment deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
