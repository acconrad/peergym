defmodule Peergym.Repo.Migrations.AddAmenitiesToGyms do
  use Ecto.Migration

  def change do
    alter table(:gyms) do
      add :size, :integer
      add :coaches, :integer
      add :class_size, :integer

      add :barbells, :integer
      add :trap_bars, :integer
      add :safety_squat_bars, :integer
      add :log_bars, :integer
      add :bandbell_bars, :integer
      add :camber_bars, :integer
      add :bumper_plates, :integer

      add :gym_chalk, :integer

      add :squat_racks, :integer
      add :power_racks, :integer
      add :pull_up_rigs, :integer
      add :monolifts, :integer
      add :benches, :integer
      add :ghds, :integer
      add :reverse_hypers, :integer
      add :platforms, :integer
      add :bands, :integer
      add :jerk_blocks, :integer
      add :bench_press_boards, :integer
      add :chains, :integer
      add :tires, :integer
      add :kegs, :integer
      add :atlas_stones, :integer

      add :kettlebells, :integer
      add :dumbbells, :integer
      add :sleds, :integer
      add :medicine_balls, :integer
      add :slam_balls, :integer
      add :sand_bags, :integer
      add :plyo_boxes, :integer
      add :rowers, :integer
      add :ergs, :integer
      add :bikes, :integer
      add :treadmills, :integer
      add :ellipticals, :integer
      add :stair_climbers, :integer
      add :jump_ropes, :integer

      add :agility, :boolean
      add :bodyweight, :boolean
      add :boxing_mma, :boolean
      add :climbing, :boolean
      add :gymnastic, :boolean
    end
  end
end
