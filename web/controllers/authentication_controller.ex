defmodule Peergym.AuthenticationController do
  use Peergym.Web, :controller

  plug :action

  def new(conn, _params) do
    render conn, "new.html"
  end
end
