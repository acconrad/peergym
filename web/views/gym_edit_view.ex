defmodule Peergym.GymEditView do
  use Peergym.Web, :view
  alias Phoenix.Controller

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

  def render("meta_description", assigns) do
    case Controller.action_name assigns.conn do
      :new  -> "Add your gym to our network of over 4000+ gyms today."
      :edit -> "Edit #{assigns.gym.name} in #{assigns.gym.city} with PeerGym."
      _     -> "Discover the best gyms in your area. " <>
               "Search over 4000+ gyms to find the best equipment, amenities, and membership rates."
    end
  end

  def render("title", assigns) do
    case Controller.action_name assigns.conn do
      :new  -> "Add a Gym to Our Network"
      :edit -> "#{assigns.gym.name} in (#{assigns.gym.state}) - Edit this Gym"
      _     -> "PeerGym: Discover the best gyms in your area and compare membership rates"
    end
  end
end
