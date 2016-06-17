defmodule Peergym.Registration do
  @moduledoc """
  A module for registering a user onto the site.
  Uses Bcrypt to securely store the password.
  """

  alias Comeonin.Bcrypt
  import Ecto.Changeset, only: [put_change: 3]

  def create(changeset, repo) do
    changeset
    |> put_change(:crypted_password, Bcrypt.hashpwsalt(changeset.params["password"]))
    |> put_change(:admin, false)
    |> repo.insert()
  end
end
