defmodule Peergym.PageController do
  use Peergym.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
