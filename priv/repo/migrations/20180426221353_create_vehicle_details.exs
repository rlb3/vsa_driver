defmodule VsaDriver.Repo.Migrations.CreateVehicleDetails do
  use Ecto.Migration

  def change do
    create table(:vehicle_details) do
      add :vehicle_type, :string
      add :turn_radius, :integer
      add :trailer_length, :integer
      add :sleeper_cab, :boolean, default: false, null: false
      add :seals, :boolean, default: false, null: false
      add :driver_id, references(:drivers, on_delete: :delete_all)

      timestamps()
    end

    create index(:vehicle_details, [:driver_id])
  end
end
