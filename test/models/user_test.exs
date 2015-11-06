defmodule Peergym.UserTest do
  use Peergym.ModelCase

  alias Peergym.User

  @valid_attrs %{email: "person@example.com", password: "test1234"}
  @missing_attrs %{email: nil, password: nil}
  @invalid_email %{email: "hi", password: "test1234"}
  @invalid_password %{email: "person@example.com", password: "test"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with missing required params" do
    changeset = User.changeset(%User{}, @missing_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid email format" do
    changeset = User.changeset(%User{}, @invalid_email)
    refute changeset.valid?
  end

  test "changeset with a password too short" do
    changeset = User.changeset(%User{}, @invalid_password)
    refute changeset.valid?
  end

  test "crypted_password value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, Ecto.Changeset.get_change(changeset, :crypted_password))
  end

  test "crypted_password value does not get set if password is nil" do
    changeset = User.changeset(%User{}, %{email: "test@test.com", password: nil})
    refute Ecto.Changeset.get_change(changeset, :crypted_password)
  end
end
