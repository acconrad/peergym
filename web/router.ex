defmodule Peergym.Router do
  use Peergym.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Peergym do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/gyms", GymController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Peergym do
  #   pipe_through :api
  # end
end
