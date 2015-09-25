defmodule Peergym.PaymentController do
  use Peergym.Web, :controller

  alias Peergym.Payment
  alias Peergym.Gym

  plug :scrub_params, "payment" when action in [:create, :update]

  def new(conn, params) do
    changeset = Payment.changeset(%Payment{})
    gym = Repo.get!(Gym, params["gym_id"])
    render(conn, "new.html", changeset: changeset, gym: gym)
  end

  def create(conn, %{"payment" => payment_params}) do
    changeset = Payment.changeset(%Payment{}, payment_params)

    case Repo.insert(changeset) do
      {:ok, _payment} ->
        conn
        |> put_flash(:info, "You're all set! Check your email for your free pass.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
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
