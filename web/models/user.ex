defmodule Peergym.User do
  @moduledoc """
  Basic module for storing User information.
  """

  use Peergym.Web, :model
  use Arc.Ecto.Schema
  alias Peergym.Avatar
  alias Peergym.Repo

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :admin, :boolean
    field :avatar, Avatar.Type
    has_many :reviews, Peergym.Review

    timestamps()
  end

  @doc """
  Creates a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :crypted_password, :password, :admin])
    |> validate_required([:email, :password])
    |> cast_attachments(params, [:avatar])
    |> unique_constraint(:email, on: Repo, downcase: true)
    |> validate_format(:email, ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/)
    |> validate_length(:password, min: 8)
  end
end
