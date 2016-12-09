defmodule Peergym.Gym do
  @moduledoc """
  Stores all information about the gyms.
  """

  use Peergym.Web, :model
  use Arc.Ecto.Schema
  alias Peergym.Avatar
  alias Peergym.GymEdit
  alias Peergym.Review
  alias Phoenix.HTML

  schema "gyms" do
    field :name, :string
    field :address, :string
    field :street, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :country, :string
    field :latitude, :float
    field :longitude, :float
    field :email, :string
    field :phone, :string
    field :url, :string
    field :description, :string
    field :hours, :string
    field :google_place_id, :string
    field :size, :integer
    field :coaches, :integer
    field :class_size, :integer

    # prices
    field :day_rate, :float
    field :monthly_rate, :float
    field :annual_rate, :float

    # bars and plates
    field :barbells, :integer
    field :womens_barbells, :integer
    field :trap_bars, :integer
    field :safety_squat_bars, :integer
    field :log_bars, :integer
    field :bandbell_bars, :integer
    field :camber_bars, :integer
    field :bumper_plates, :integer

    # accessories
    field :gym_chalk, :boolean

    # strength equipment
    field :squat_racks, :integer
    field :power_racks, :integer
    field :pull_up_rigs, :integer
    field :monolifts, :integer
    field :dumbbells, :integer
    field :kettlebells, :integer
    field :benches, :integer
    field :ghds, :integer
    field :reverse_hypers, :integer
    field :platforms, :integer
    field :bands, :integer
    field :jerk_blocks, :integer
    field :bench_press_boards, :integer
    field :chains, :integer

    # conditioning equipment
    field :sleds, :integer
    field :medicine_balls, :integer
    field :slam_balls, :integer
    field :sand_bags, :integer
    field :plyo_boxes, :integer
    field :ergs, :integer
    field :bikes, :integer
    field :treadmills, :integer
    field :ellipticals, :integer
    field :stair_climbers, :integer
    field :jump_ropes, :integer
    field :tires, :integer

    # misc equipment
    field :agility, :boolean # cones, ladders, hurdles
    field :bodyweight, :boolean # abmats, weighted vests, pull up bars, dip bars
    field :boxing_mma, :boolean # ring, gloves, protection, heavy bags, speed bags
    field :climbing, :boolean # ropes, rock wall, bouldering
    field :gymnastic, :boolean # rings, parallettes
    field :kegs, :integer
    field :atlas_stones, :integer
    field :other, :string
    field :photos, Avatar.Type

    has_many :reviews, Review
    has_many :gym_edits, GymEdit

    timestamps
  end

  @required_fields ~w(name address latitude longitude)
  @optional_fields ~w(street city state zip country email phone url description hours google_place_id size
    day_rate monthly_rate annual_rate coaches class_size barbells womens_barbells trap_bars safety_squat_bars log_bars
    bandbell_bars camber_bars bumper_plates gym_chalk squat_racks power_racks pull_up_rigs monolifts benches ghds
    reverse_hypers platforms bands jerk_blocks bench_press_boards chains tires kegs atlas_stones kettlebells dumbbells
    sleds medicine_balls slam_balls sand_bags plyo_boxes ergs bikes treadmills ellipticals stair_climbers jump_ropes
    agility bodyweight boxing_mma climbing gymnastic other)
  @file_fields ~w(photos)
  @delta 0.1448293334 # approx. 5 mi in lat/lng

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:reviews)
    |> cast_attachments(params, @file_fields)
    |> unique_constraint(:google_place_id)
    |> strip_tags(params)
    |> strip_unsafe(params)
  end

  def by_city(query, city) do
    from g in query,
    where: g.city == ^city
  end

  def by_slug(query, slug) do
    from g in query,
    where: fragment("lower(?)", g.name) == ^slug
  end

  def by_state(query ,state) do
    from g in query,
    where: g.state == ^state
  end

  def by_type(query, type) do
    case type do
      "crossfit" -> crossfit(query)
      "strongman" -> strongman(query)
      "powerlifting" -> powerlifting(query)
      "weightlifting" -> weightlifting(query)
      "olympic-lifting" -> weightlifting(query)
    end
  end

  def crossfit(query) do
    from g in query,
    where: ilike(g.name, "crossfit%")
  end

  def in_major_us_cities(query, ordered) do
    from g in query,
    where: g.city == "New York" or
      g.city == "Los Angeles" or
      g.city == "Chicago" or
      g.city == "Houston" or
      g.city == "Philadelphia" or
      g.city == "Phoenix" or
      g.city == "San Francisco" or
      g.city == "Boston" and
      g.monthly_rate > 0,
    order_by: [g.monthly_rate],
    limit: 50
  end
  def in_major_us_cities(query) do
    from g in query,
    where: g.city == "New York" or
      g.city == "Los Angeles" or
      g.city == "Chicago" or
      g.city == "Houston" or
      g.city == "Philadelphia" or
      g.city == "Phoenix" or
      g.city == "San Francisco" or
      g.city == "Boston",
    limit: 50
  end

  def powerlifting(query) do
    from g in query,
    where: g.id > 0
  end

  def strongman(query) do
    from g in query,
    where: g.atlas_stones > 1 or g.log_bars > 1 or g.kegs > 1
  end

  def weightlifting(query) do
    from g in query,
    where: g.platforms > 1 and g.jerk_blocks > 1 and g.bumper_plates > 1
  end

  def within_bounding_box(query, %{"lat" => lat, "lng" => lng}, ordered) do
    bounding_box = bounding_box(lat, lng)

    from g in query,
    where: g.latitude >= bounding_box.min_lat and
      g.latitude <= bounding_box.max_lat and
      g.longitude >= bounding_box.min_lng and
      g.longitude <= bounding_box.max_lng and
      g.monthly_rate > 0,
    order_by: [g.monthly_rate]
  end
  def within_bounding_box(query, %{"lat" => lat, "lng" => lng}) do
    bounding_box = bounding_box(lat, lng)

    from g in query,
    where: g.latitude >= bounding_box.min_lat and
      g.latitude <= bounding_box.max_lat and
      g.longitude >= bounding_box.min_lng and
      g.longitude <= bounding_box.max_lng
  end

  defp bounding_box(lat, lng) do
    latf = String.to_float(lat)
    lngf = String.to_float(lng)

    %{min_lat: latf - @delta,
      max_lat: latf + @delta,
      min_lng: lngf - @delta,
      max_lng: lngf + @delta}
  end

  defp strip_tag(description, tag) do
    description |> String.replace(~r{<#{tag}[^>]*>[^<>]*(</#{tag}>)*}i, "")
  end

  defp strip_tags(model, %{"description" => description}) do
    strip_descr =
      description
      |> strip_tag("script")
      |> strip_tag("iframe")
      |> strip_tag("link")
    model |> put_change(:description, strip_descr)
  end

  defp strip_unsafe(model, %{"description" => description}) do
    {:safe, clean_descr} = HTML.html_escape(description)
    model |> put_change(:description, clean_descr)
  end
end
