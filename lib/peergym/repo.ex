defmodule Peergym.Repo do
  use Ecto.Repo, otp_app: :peergym
  use Scrivener, page_size: 10
end
