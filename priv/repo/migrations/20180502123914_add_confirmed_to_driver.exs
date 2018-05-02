defmodule VsaDriver.Repo.Migrations.AddConfirmedToDriver do
  use Ecto.Migration

  def change do
    alter table(:drivers) do
      add :confirmed, :boolean, default: false, null: false
    end
  end
end
