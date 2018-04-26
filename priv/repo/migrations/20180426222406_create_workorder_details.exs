defmodule VsaDriver.Repo.Migrations.CreateWorkorderDetails do
  use Ecto.Migration

  def change do
    create table(:workorder_details) do
      add :poc_name, :string
      add :poc_phone, :string
      add :poc_extention, :string
      add :cargo_content, :string
      add :driver_id, references(:drivers, on_delete: :delete_all)

      timestamps()
    end

    create index(:workorder_details, [:driver_id])
  end
end
