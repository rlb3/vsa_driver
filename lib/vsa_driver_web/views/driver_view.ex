defmodule VsaDriverWeb.DriverView do
  use VsaDriverWeb, :view
  alias VsaDriverWeb.DriverView
  use JaSerializer.PhoenixView

  attributes([
    :badge_number,
    :company,
    :email,
    :first_name,
    :frequent,
    :hazmat_authorized,
    :last_name,
    :license,
    :password_confirmation_number,
    :password_expires,
    :phone_number,
    :confirm
  ])

  @default_includes [:vehicle_details, :workorder_details]
  def preload(record_or_records, _conn, []) do
    VsaDriver.Repo.preload(record_or_records, @default_includes)
  end

  has_one(
    :vehicle_details,
    serializer: VsaDriverWeb.VehicleDetailSerializer,
    include: true
  )

  has_one(
    :workorder_details,
    serializer: VsaDriverWeb.WorkorderDetailSerializer,
    include: true
  )
end
