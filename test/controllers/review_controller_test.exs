defmodule Peergym.ReviewControllerTest do
  use Peergym.ConnCase

  alias Peergym.Review
  alias Peergym.User
  alias Peergym.Registration
  @valid_attrs %{body: "some content", rating: 42}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
    conn = post conn, session_path(conn, :create), session: loggedin_user
    gym = create(:gym)
    {:ok, conn: conn, gym: gym}
  end

  defp loggedin_user do
    {:ok, _user} = Registration.create(User.changeset(%User{}, %{
      password: "test1234",
      email: "test@test.com"}), Peergym.Repo)
    %{"email" => "test@test.com", "password" => "test1234"}
  end

  test "lists all entries on index", %{conn: conn, gym: gym} do
    conn = get conn, gym_review_path(conn, :index, gym)
    assert html_response(conn, 200) =~ "Listing reviews"
  end

  test "renders form for new resources", %{conn: conn, gym: gym} do
    conn = get conn, gym_review_path(conn, :new, gym)
    assert html_response(conn, 200) =~ "New review"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, gym: gym} do
    conn = post conn, gym_review_path(conn, :create, gym), review: @valid_attrs
    assert redirected_to(conn) == gym_review_path(conn, :index, gym)
    assert Repo.get_by(Review, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, gym: gym} do
    conn = post conn, gym_review_path(conn, :create, gym), review: @invalid_attrs
    assert html_response(conn, 200) =~ "New review"
  end

  test "shows chosen resource", %{conn: conn, gym: gym} do
    review = Repo.insert! %Review{}
    conn = get conn, gym_review_path(conn, :show, gym, review)
    assert html_response(conn, 200) =~ "Show review"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, gym: gym} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, gym_review_path(conn, :show, gym, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, gym: gym} do
    review = Repo.insert! %Review{}
    conn = get conn, gym_review_path(conn, :edit, gym, review)
    assert html_response(conn, 200) =~ "Edit review"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, gym: gym} do
    review = Repo.insert! %Review{}
    conn = put conn, gym_review_path(conn, :update, gym, review), review: @valid_attrs
    assert redirected_to(conn) == gym_review_path(conn, :show, gym, review)
    assert Repo.get_by(Review, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, gym: gym} do
    review = Repo.insert! %Review{}
    conn = put conn, gym_review_path(conn, :update, gym, review), review: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit review"
  end

  test "deletes chosen resource", %{conn: conn, gym: gym} do
    review = Repo.insert! %Review{}
    conn = delete conn, gym_review_path(conn, :delete, gym, review)
    assert redirected_to(conn) == gym_review_path(conn, :index, gym)
    refute Repo.get(Review, review.id)
  end
end
