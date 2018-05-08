defmodule VsaDriverWeb.VehicleDetailView do
  use VsaDriverWeb, :view
  use JaSerializer.PhoenixView

  attributes([:seals, :sleeper_cab, :trailer_length, :turn_radius, :vehicle_type])
end
