defmodule Peergym.GymView do
  use Peergym.Web, :view
  alias Phoenix.Controller
  import Number.Currency
  import Number.Delimit

  @states [
    AL: "Alabama",
    AK: "Alaska",
    AZ: "Arizona",
    AR: "Arkansas",
    CA: "California",
    CO: "Colorado",
    CT: "Connecticut",
    DE: "Delaware",
    FL: "Florida",
    GA: "Georgia",
    HI: "Hawaii",
    ID: "Idaho",
    IL: "Illinois",
    IN: "Indiana",
    IA: "Iowa",
    KS: "Kansas",
    KY: "Kentucky",
    LA: "Louisiana",
    ME: "Maine",
    MD: "Maryland",
    MA: "Massachusetts",
    MI: "Michigan",
    MN: "Minnesota",
    MS: "Mississippi",
    MO: "Missouri",
    MT: "Montana",
    NE: "Nebraska",
    NV: "Nevada",
    NH: "New Hampshire",
    NJ: "New Jersey",
    NM: "New Mexico",
    NY: "New York",
    NC: "North Carolina",
    ND: "North Dakota",
    OH: "Ohio",
    OK: "Oklahoma",
    OR: "Oregon",
    PA: "Pennsylvania",
    RI: "Rhode Island",
    SC: "South Carolina",
    SD: "South Dakota",
    TN: "Tennessee",
    TX: "Texas",
    UT: "Utah",
    VT: "Vermont",
    VA: "Virginia",
    WA: "Washington",
    WV: "West Virginia",
    WI: "Wisconsin",
    WY: "Wyoming"
  ]

  def format_amenity(amenity) do
    cond do
      amenity == nil                       -> "N/A"
      (amenity == 0) || (amenity == false) -> "No"
      (amenity == 1) || (amenity == true)  -> "Yes"
      amenity -> amenity
    end
  end

  def format_max_amenity(amenity) do
    if amenity > 1 do
      "Up to #{amenity} lbs"
    else
      format_amenity amenity
    end
  end

  def img_url(gym) do
    if gym.photos do
      "https://d2ohrei45269ks.cloudfront.net/uploads/gyms/photos/#{gym.id}/#{gym.id}_original_#{gym.photos.file_name}"
    else
      "/images/background.jpg"
    end
  end

  def list_rate(gym) do
    cond do
      gym.monthly_rate > 0 -> "<span class=\"amt\">#{number_to_currency(gym.monthly_rate, precision: 0)}</span> / mo"
      gym.day_rate > 0     -> "<span class=\"amt\">#{number_to_currency(gym.day_rate, precision: 0)}</span> / day"
      gym.annual_rate > 0  -> "<span class=\"amt\">#{number_to_currency(gym.annual_rate, precision: 0)}</span> / yr"
      true -> ""
    end
  end

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end

  def render("meta_description", assigns) do
    case Controller.action_name assigns.conn do
      :indow -> "Discover the best gyms in #{assigns.gym.city}, #{assigns.gym.state} with PeerGym."
      :show  -> "Book #{assigns.gym.name}, #{assigns.gym.city} on PeerGym: " <>
                "See amenities, photos, and great deals for #{assigns.gym.name}."
      _      -> "Discover the best gyms in your area. " <>
                "Search over 4000+ gyms to find the best equipment, amenities, and membership rates."
    end
  end

  def render("title", assigns) do
    case Controller.action_name assigns.conn do
      :index ->
        if assigns.location["city"] do
          "The Best #{assigns.location["city"]} Gyms"
        else
          "PeerGym: Discover the best gyms in your area and compare membership rates"
        end
      :show  -> "#{assigns.gym.name} in (#{assigns.gym.state}) - Gym Reviews"
      _      -> "PeerGym: Discover the best gyms in your area and compare membership rates"
    end
  end

  def slug(gym) do
    gym.name
    |> String.downcase
    |> String.replace(" ", "-")
  end

  def full_state_name(state) do
    @states[String.to_atom(state)]
  end
end
