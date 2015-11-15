defmodule Peergym.Gym do
  use Peergym.Web, :model

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

    # bars and plates
    field :barbells, :integer
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
    field :benches, :integer
    field :ghds, :integer
    field :reverse_hypers, :integer
    field :platforms, :integer
    field :bands, :integer
    field :jerk_blocks, :integer
    field :bench_press_boards, :integer
    field :chains, :integer
    field :tires, :integer
    field :kegs, :integer
    field :atlas_stones, :integer

    # conditioning equipment
    field :kettlebells, :integer
    field :dumbbells, :integer
    field :sleds, :integer
    field :medicine_balls, :integer
    field :slam_balls, :integer
    field :sand_bags, :integer
    field :plyo_boxes, :integer
    field :rowers, :integer
    field :ergs, :integer
    field :bikes, :integer
    field :treadmills, :integer
    field :ellipticals, :integer
    field :stair_climbers, :integer
    field :jump_ropes, :integer

    # misc equipment
    field :agility, :boolean # cones, ladders, hurdles
    field :bodyweight, :boolean # abmats, weighted vests, pull up bars, dip bars
    field :boxing_mma, :boolean # ring, gloves, protection, heavy bags, speed bags
    field :climbing, :boolean # ropes, rock wall, bouldering
    field :gymnastic, :boolean # rings, parallettes

    timestamps
  end

  @required_fields ~w(name address latitude longitude)
  @optional_fields ~w(street city state zip country email phone url description hours google_place_id size coaches class_size barbells trap_bars safety_squat_bars log_bars bandbell_bars camber_bars bumper_plates gym_chalk squat_racks power_racks pull_up_rigs monolifts benches ghds reverse_hypers platforms bands jerk_blocks bench_press_boards chains tires kegs atlas_stones kettlebells dumbbells sleds medicine_balls slam_balls sand_bags plyo_boxes rowers ergs bikes treadmills ellipticals stair_climbers jump_ropes agility bodyweight boxing_mma climbing gymnastic)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    # |> unique_constraint(:google_place_id)
  end
end
