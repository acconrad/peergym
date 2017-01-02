defmodule Peergym.GymEditView do
  use Peergym.Web, :view

  def img_url(%{gym: gym}) do
    if gym.photos do
      "https://d2ohrei45269ks.cloudfront.net/uploads/gyms/photos/#{gym.id}/#{gym.id}_original_#{gym.photos.file_name}"
    else
      "/images/thumb.png"
    end
  end
  def img_url(_changeset) do
    "/images/thumb.png"
  end
end
