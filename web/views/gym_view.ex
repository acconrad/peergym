defmodule Peergym.GymView do
  use Peergym.Web, :view

  def render("meta_description", assigns) do
    case Phoenix.Controller.action_name assigns.conn do
      :show -> "#{assigns.gym.name}, located in #{assigns.gym.city}, #{assigns.gym.state}. #{assigns.gym.description}."
      _ -> "Discover the best gyms in your area with PeerGym"
    end
  end

  def render("title", assigns) do
    case Phoenix.Controller.action_name assigns.conn do
      :index -> "Gyms near #{assigns.place}"
      :show -> "#{assigns.gym.name} in #{assigns.gym.city}, #{assigns.gym.state}"
      _ -> "Discover the best gyms in your area with PeerGym"
    end
  end

  def full_state_name(state) do
    case state do
      "AL" -> "Alabama"
      "AK" -> "Alaska"
      "AZ" -> "Arizona"
      "AR" -> "Arkansas"
      "CA" -> "California"
      "CO" -> "Colorado"
      "CT" -> "Connecticut"
      "DE" -> "Delaware"
      "FL" -> "Florida"
      "GA" -> "Georgia"
      "HI" -> "Hawaii"
      "ID" -> "Idaho"
      "IL" -> "Illinois"
      "IN" -> "Indiana"
      "IA" -> "Iowa"
      "KS" -> "Kansas"
      "KY" -> "Kentucky"
      "LA" -> "Louisiana"
      "ME" -> "Maine"
      "MD" -> "Maryland"
      "MA" -> "Massachusetts"
      "MI" -> "Michigan"
      "MN" -> "Minnesota"
      "MS" -> "Mississippi"
      "MO" -> "Missouri"
      "MT" -> "Montana"
      "NE" -> "Nebraska"
      "NV" -> "Nevada"
      "NH" -> "New Hampshire"
      "NJ" -> "New Jersey"
      "NM" -> "New Mexico"
      "NY" -> "New York"
      "NC" -> "North Carolina"
      "ND" -> "North Dakota"
      "OH" -> "Ohio"
      "OK" -> "Oklahoma"
      "OR" -> "Oregon"
      "PA" -> "Pennsylvania"
      "RI" -> "Rhode Island"
      "SC" -> "South Carolina"
      "SD" -> "South Dakota"
      "TN" -> "Tennessee"
      "TX" -> "Texas"
      "UT" -> "Utah"
      "VT" -> "Vermont"
      "VA" -> "Virginia"
      "WA" -> "Washington"
      "WV" -> "West Virginia"
      "WI" -> "Wisconsin"
      "WY" -> "Wyoming"
    end
  end
end
