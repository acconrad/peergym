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
    |> send_resp(200, "1yIc6C_eORUTSvBNErsGqhHo2SPVGb1ikrN1H9xQ0ko.EStPalDZwLiI26y7DYKCPHtMvNn5jm6pBrM8cSTwDCQ")
  end
end
