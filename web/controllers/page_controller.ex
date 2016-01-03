defmodule Peergym.PageController do
  use Peergym.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def ssl(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(201, "MEDhNkkRS_hT7hfMUY6rgV9O8ORm_Z7MpAS1Oheh9yE.EStPalDZwLiI26y7DYKCPHtMvNn5jm6pBrM8cSTwDCQ")
  end

  def sslx(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(201, "1yIc6C_eORUTSvBNErsGqhHo2SPVGb1ikrN1H9xQ0ko.EStPalDZwLiI26y7DYKCPHtMvNn5jm6pBrM8cSTwDCQ")
  end
end
