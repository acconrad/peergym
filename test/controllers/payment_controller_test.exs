defmodule Peergym.PaymentControllerTest do
  use Peergym.ConnCase

  alias Peergym.Payment
  @valid_attrs %{cc_number: 42, cvc: 42, month: 42, name: "some content", year: 42, zip: 42}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, payment_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing payments"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, payment_path(conn, :new)
    assert html_response(conn, 200) =~ "New payment"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, payment_path(conn, :create), payment: @valid_attrs
    assert redirected_to(conn) == payment_path(conn, :index)
    assert Repo.get_by(Payment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, payment_path(conn, :create), payment: @invalid_attrs
    assert html_response(conn, 200) =~ "New payment"
  end

  test "shows chosen resource", %{conn: conn} do
    payment = Repo.insert! %Payment{}
    conn = get conn, payment_path(conn, :show, payment)
    assert html_response(conn, 200) =~ "Show payment"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, payment_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    payment = Repo.insert! %Payment{}
    conn = get conn, payment_path(conn, :edit, payment)
    assert html_response(conn, 200) =~ "Edit payment"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    payment = Repo.insert! %Payment{}
    conn = put conn, payment_path(conn, :update, payment), payment: @valid_attrs
    assert redirected_to(conn) == payment_path(conn, :show, payment)
    assert Repo.get_by(Payment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    payment = Repo.insert! %Payment{}
    conn = put conn, payment_path(conn, :update, payment), payment: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit payment"
  end

  test "deletes chosen resource", %{conn: conn} do
    payment = Repo.insert! %Payment{}
    conn = delete conn, payment_path(conn, :delete, payment)
    assert redirected_to(conn) == payment_path(conn, :index)
    refute Repo.get(Payment, payment.id)
  end
end
