defmodule VsaDriverWeb.VehicleDetailSerializer do
  use JaSerializer

  # location("/drivers/:driver_id/vehicle_details")
  attributes([:seals, :sleeper_cab, :trailer_length, :turn_radius, :vehicle_type])
end
