defmodule Peergym.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def acl(:thumb, _), do: :public_read

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, {file, scope}) do
    [name, _] = file.file_name |> String.split(~r{\.(jpg|png|jpeg|gif)})
    "#{scope.id}_#{version}_#{name}"
  end

  def storage_dir(version, {file, scope}) do
    "uploads/gyms/photos/#{scope.id}"
  end

  def default_url(version) do
    MyApp.Endpoint.url <> "/images/background.jpg"
  end
end
