defmodule Peergym.Avatar do
  @moduledoc """
  A module for uploading and defining background photos for gyms.
  This is part of the Arc S3 image package.
  """

  use Arc.Definition
  use Arc.Ecto.Definition
  alias Peergym.Endpoint

  @versions [:original]

  def acl(:thumb, _), do: :public_read

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {file, scope}) do
    [name, _] = file.file_name |> String.split(~r{\.(jpg|png|jpeg|gif)})
    "#{scope.id}_#{version}_#{name}"
  end

  def storage_dir(_version, {_, scope}) do
    "uploads/gyms/photos/#{scope.id}"
  end

  def default_url(_version) do
    Endpoint.url <> "/images/background.jpg"
  end
end
