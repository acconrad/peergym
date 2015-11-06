defmodule Peergym.PaymentController do
  use Peergym.Web, :controller

  alias Peergym.Payment
  alias Peergym.Gym
  alias Peergym.User

  plug :scrub_params, "payment" when action in [:create]

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
end
