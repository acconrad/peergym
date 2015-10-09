defmodule Peergym.Registration do
  import Ecto.Changeset, only: [put_change: 3]

  def create(changeset, repo) do
    changeset
    |> put_change(:crypted_password, Comeonin.Bcrypt.hashpwsalt(changeset.params["password"]))
    |> put_change(:admin, false)
    |> repo.insert()
  end
end
