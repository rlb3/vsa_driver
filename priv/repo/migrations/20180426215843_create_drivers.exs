defmodule VsaDriver.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :email, :string
      add :license, :string
      add :first_name, :string
      add :last_name, :string
      add :phone_number, :string
      add :company, :string
      add :hazmat_authorized, :boolean, default: false, null: false
      add :frequent, :boolean, default: false, null: false
      add :badge_number, :string
      add :password_hash, :string
      add :password_expires, :utc_datetime
      add :password_confirmation_number, :string

      timestamps()
    end

    create unique_index(:drivers, [:email])
    create unique_index(:drivers, [:license])
  end
end
