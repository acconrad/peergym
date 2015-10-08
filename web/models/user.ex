defmodule Peergym.User do
  use Peergym.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :admin, :boolean

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w(crypted_password admin)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> put_change(:crypted_password, Comeonin.Bcrypt.hashpwsalt(params["password"]))
    |> unique_constraint(:email)
  end
end
