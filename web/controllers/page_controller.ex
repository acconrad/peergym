defmodule Peergym.PageController do
  use Peergym.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def ssl(conn, _params) do
    conn
    |> send_resp(200, "anZ6cAz6NL80HOG2A2zYdofckE-qhn-gMxCbgMp_FJc.EStPalDZwLiI26y7DYKCPHtMvNn5jm6pBrM8cSTwDCQ")
  end

  def sslx(conn, _params) do
    conn
    |> send_resp(200, "QM1QqSDFZjNLDJXR5Hc_6QQO7KIymfnvrc9wllkjkeA.EStPalDZwLiI26y7DYKCPHtMvNn5jm6pBrM8cSTwDCQ")
  end
end
