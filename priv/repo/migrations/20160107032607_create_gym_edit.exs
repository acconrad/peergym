defmodule Peergym.Repo.Migrations.CreateGymEdit do
  use Ecto.Migration

  def change do
    create table(:gym_edits) do
      add :name, :string
      add :address, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :email, :string
      add :phone, :string
      add :url, :string
      add :description, :string
      add :hours, :string
      add :size, :integer
      add :coaches, :integer
      add :class_size, :integer
      add :day_rate, :float
      add :monthly_rate, :float
      add :annual_rate, :float
      add :is_owner, :boolean, default: false
      add :submitter_email, :string
      add :closed, :boolean, default: false
      add :gym_id, references(:gyms)
      add :barbells, :integer
      add :womens_barbells, :integer
      add :trap_bars, :integer
      add :safety_squat_bars, :integer
      add :log_bars, :integer
      add :bandbell_bars, :integer
      add :camber_bars, :integer
      add :bumper_plates, :integer
      add :gym_chalk, :boolean
      add :squat_racks, :integer
      add :power_racks, :integer
      add :pull_up_rigs, :integer
      add :monolifts, :integer
      add :dumbbells, :integer
      add :kettlebells, :integer
      add :benches, :integer
      add :ghds, :integer
      add :reverse_hypers, :integer
      add :platforms, :integer
      add :bands, :integer
      add :jerk_blocks, :integer
      add :bench_press_boards, :integer
      add :chains, :integer
      add :sleds, :integer
      add :medicine_balls, :integer
      add :slam_balls, :integer
      add :sand_bags, :integer
      add :plyo_boxes, :integer
      add :ergs, :integer
      add :bikes, :integer
      add :treadmills, :integer
      add :ellipticals, :integer
      add :stair_climbers, :integer
      add :jump_ropes, :integer
      add :tires, :integer
      add :agility, :boolean
      add :bodyweight, :boolean
      add :boxing_mma, :boolean
      add :climbing, :boolean
      add :gymnastic, :boolean
      add :kegs, :integer
      add :atlas_stones, :integer
      add :photos, :string

      timestamps
    end
    create index(:gym_edits, [:gym_id])

  end
end
