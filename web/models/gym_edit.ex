defmodule Peergym.GymEdit do
  @moduledoc """
  A module to allow Users to edit information about Gyms.
  These are essentially temporary, ephemeral snapshots of a Gym that can be used
  to quickly update a Gym via User input rather than manually updating as an admin.
  """

  use Peergym.Web, :model
  use Arc.Ecto.Schema

  schema "gym_edits" do
    field :name, :string
    field :address, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    field :email, :string
    field :phone, :string
    field :url, :string
    field :hours, :string
    field :size, :integer
    field :coaches, :integer
    field :class_size, :integer
    field :closed, :boolean, default: false

    # prices
    field :day_rate, :float
    field :monthly_rate, :float
    field :annual_rate, :float

    # verification
    field :is_owner, :boolean, default: false
    field :submitter_email, :string
    field :description, :string

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
    field :photos, Peergym.Avatar.Type

    belongs_to :gym, Peergym.Gym

    timestamps
  end

  @required_fields ~w(name address city)
  @optional_fields ~w(state zip email phone url description hours size coaches class_size day_rate monthly_rate
    annual_rate is_owner submitter_email closed barbells womens_barbells trap_bars safety_squat_bars log_bars
    bandbell_bars camber_bars bumper_plates gym_chalk squat_racks power_racks pull_up_rigs monolifts benches ghds
    reverse_hypers platforms bands jerk_blocks bench_press_boards chains tires kegs atlas_stones kettlebells dumbbells
    sleds medicine_balls slam_balls sand_bags plyo_boxes ergs bikes treadmills ellipticals stair_climbers jump_ropes
    agility bodyweight boxing_mma climbing gymnastic gym_id)
  @file_fields ~w(photos)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @file_fields)
  end
end
