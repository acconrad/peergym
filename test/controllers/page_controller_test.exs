defmodule Peergym.PageControllerTest do
  use Peergym.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "gyms-list"
  end
end
