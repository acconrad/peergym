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

    resources "users", UserController
    get  "/signup", UserController, :new
    post "/signup", UserController, :create

    get  "/signin", SessionController, :new
    post "/signin", SessionController, :create
    get  "/signout", SessionController, :delete

    get "/", GymController, :index
    resources "gyms", GymController do
      resources "payments", PaymentController
      resources "reviews", ReviewController
    end
    get "/:slug", GymController, :index

    get "/.well-known/acme-challenge/anZ6cAz6NL80HOG2A2zYdofckE-qhn-gMxCbgMp_FJc", PageController, :ssl
    get "/.well-known/acme-challenge/1yIc6C_eORUTSvBNErsGqhHo2SPVGb1ikrN1H9xQ0ko", PageController, :sslx
  end

  # Other scopes may use custom stacks.
  # scope "/api", Peergym do
  #   pipe_through :api
  # end
end
