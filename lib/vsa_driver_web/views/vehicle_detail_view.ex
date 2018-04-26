defmodule VsaDriverWeb.VehicleDetailView do
  use VsaDriverWeb, :view
  alias VsaDriverWeb.VehicleDetailView

  def render("index.json", %{vehicle_details: vehicle_details}) do
    %{data: render_many(vehicle_details, VehicleDetailView, "vehicle_detail.json")}
  end

  def render("show.json", %{vehicle_detail: vehicle_detail}) do
    %{data: render_one(vehicle_detail, VehicleDetailView, "vehicle_detail.json")}
  end

  def render("vehicle_detail.json", %{vehicle_detail: vehicle_detail}) do
    %{
      id: vehicle_detail.id,
      vehicle_type: vehicle_detail.vehicle_type,
      turn_radius: vehicle_detail.turn_radius,
      trailer_length: vehicle_detail.trailer_length,
      sleeper_cab: vehicle_detail.sleeper_cab,
      seals: vehicle_detail.seals
    }
  end
end
