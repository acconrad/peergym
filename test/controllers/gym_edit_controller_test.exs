defmodule Peergym.GymEditControllerTest do
  use Peergym.ConnCase

  alias Peergym.GymEdit
  @valid_attrs %{address: "some content", annual_rate: "120.5", city: "some content", class_size: 42, closed: true, coaches: 42, day_rate: "120.5", description: "some content", email: "some content", hours: "some content", is_owner: true, monthly_rate: "120.5", name: "some content", phone: "some content", size: 42, state: "some content", submitter_email: "some content", url: "some content", zip: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, gym_edit_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing gym edits"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, gym_edit_path(conn, :new)
    assert html_response(conn, 200) =~ "New gym edit"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, gym_edit_path(conn, :create), gym_edit: @valid_attrs
    assert redirected_to(conn) == gym_edit_path(conn, :index)
    assert Repo.get_by(GymEdit, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, gym_edit_path(conn, :create), gym_edit: @invalid_attrs
    assert html_response(conn, 200) =~ "New gym edit"
  end

  test "shows chosen resource", %{conn: conn} do
    gym_edit = Repo.insert! %GymEdit{}
    conn = get conn, gym_edit_path(conn, :show, gym_edit)
    assert html_response(conn, 200) =~ "Show gym edit"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, gym_edit_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    gym_edit = Repo.insert! %GymEdit{}
    conn = get conn, gym_edit_path(conn, :edit, gym_edit)
    assert html_response(conn, 200) =~ "Edit gym edit"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    gym_edit = Repo.insert! %GymEdit{}
    conn = put conn, gym_edit_path(conn, :update, gym_edit), gym_edit: @valid_attrs
    assert redirected_to(conn) == gym_edit_path(conn, :show, gym_edit)
    assert Repo.get_by(GymEdit, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    gym_edit = Repo.insert! %GymEdit{}
    conn = put conn, gym_edit_path(conn, :update, gym_edit), gym_edit: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit gym edit"
  end

  test "deletes chosen resource", %{conn: conn} do
    gym_edit = Repo.insert! %GymEdit{}
    conn = delete conn, gym_edit_path(conn, :delete, gym_edit)
    assert redirected_to(conn) == gym_edit_path(conn, :index)
    refute Repo.get(GymEdit, gym_edit.id)
  end
end
