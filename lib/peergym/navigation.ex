defmodule Peergym.Navigation do
  @moduledoc """
  Helper functions for calculating global navigation.
  """
  @boston_lat 42.3600825  # Latitude of the center of Boston, MA
  @boston_lng -71.0588801 # Longitude of the center of Boston, MA
  @earth_radius 6372.8    # Approximation of the radius of the average circumference of the Earth
  @radians :math.pi / 180 # Degrees to radians conversion

  @doc """
  Given an IP address, find the location to search against.
  """
  def find_location(ip_address) do
    case Geolix.lookup(ip_address).city do
      %{city: city, location: location, subdivisions: state} ->
        %{"lat"   => location.latitude,
          "lng"   => location.longitude,
          "city"  => city.names.en,
          "state" => state |> List.first.iso_code}
      %{city: city, country: country, location: location} ->
        %{"lat"   => location.latitude,
          "lng"   => location.longitude,
          "city"  => city.names.en,
          "state" => country.names.en}
      %{location: location, subdivisions: state} ->
        %{"lat"   => location.latitude,
          "lng"   => location.longitude,
          "city"  => "",
          "state" => state |> List.first.iso_code}
      %{country: country, location: location} ->
        %{"lat"   => location.latitude,
          "lng"   => location.longitude,
          "city"  => "",
          "state" => country.names.en}
      _ ->
        %{"lat"   => @boston_lat,
          "lng"   => @boston_lng,
          "city"  => "Boston",
          "state" => "MA"}
    end
  end

  @doc """
  The haversine formula calculates great-circle distances between two points on a sphere
  from their longitudes and latitudes.
  """
  def haversine(%{"latitude" => lat1, "longitude" => long1}, %{"lat" => lat2, "lng" => long2}) do
    dlat  = :math.sin((lat2 - lat1) * @radians / 2)
    dlong = :math.sin((long2 - long1) * @radians / 2)
    a = dlat * dlat + dlong * dlong * :math.cos(lat1 * @radians) * :math.cos(lat2 * @radians)
    @earth_radius * 2 * :math.asin(:math.sqrt(a))
  end
end
