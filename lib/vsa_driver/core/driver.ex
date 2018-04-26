defmodule VsaDriver.Core.Driver do
  use Ecto.Schema
  import Ecto.Changeset


  schema "drivers" do
    field :badge_number, :string
    field :company, :string
    field :email, :string
    field :first_name, :string
    field :frequent, :boolean, default: false
    field :hazmat_authorized, :boolean, default: false
    field :last_name, :string
    field :license, :string
    field :password_confirmation_number, :string
    field :password_expires, :utc_datetime
    field :password_hash, :string
    field :phone_number, :string
    has_one :vehicle_details, VsaDriver.Core.VehicleDetail
    has_one :workorder_details, VsaDriver.Core.WorkorderDetail

    timestamps()
  end

  @doc false
  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:email, :license, :first_name, :last_name, :phone_number, :company, :hazmat_authorized, :frequent, :badge_number, :password_hash, :password_expires, :password_confirmation_number])
    |> validate_required([:email, :license, :first_name, :last_name, :phone_number, :company, :hazmat_authorized, :frequent, :badge_number, :password_hash, :password_expires, :password_confirmation_number])
  end
end
