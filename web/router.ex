defmodule Peergym.Router do
  use Peergym.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Peergym do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "gyms", GymController do
      resources "payments", PaymentController
    end

    # Passport auth routes
    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
    get "/signout", SessionController, :delete

    get "/signup", RegistrationController, :new
    post "/signup", RegistrationController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", Peergym do
  #   pipe_through :api
  # end
end
