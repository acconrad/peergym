defmodule Peergym.User do
  use Peergym.Web, :model
  use Arc.Ecto.Model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :admin, :boolean
    field :avatar, Peergym.Avatar.Type
    has_many :reviews, Peergym.Review

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w(crypted_password admin)

  @required_file_fields ~w()
  @optional_file_fields ~w(avatar)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
    |> unique_constraint(:email, on: Peergym.Repo, downcase: true)
    |> validate_format(:email, ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/)
    |> validate_length(:password, min: 8)
  end
end
