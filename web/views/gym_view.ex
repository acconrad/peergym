defmodule Peergym.GymView do
  use Peergym.Web, :view

  def render("meta_description", assigns) do
    case Phoenix.Controller.action_name assigns.conn do
      _ -> "Buy drop-in passes to great gyms without the painful contracts"
    end
  end

  def render("title", assigns) do
    case Phoenix.Controller.action_name assigns.conn do
      :index -> "Gyms near #{assigns.place}"
      :show -> "#{assigns.gym.name} in #{assigns.gym.city}, #{assigns.gym.state}"
      _ -> "Buy drop-in passes to great gyms without the painful contracts"
    end
  end
end
