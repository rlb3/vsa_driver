defmodule VsaDriverWeb.VehicleDetailController do
  use VsaDriverWeb, :controller

  alias VsaDriver.Core
  alias VsaDriver.Core.VehicleDetail

  action_fallback VsaDriverWeb.FallbackController

  def index(conn, _params) do
    vehicle_details = Core.list_vehicle_details()
    render(conn, "index.json", vehicle_details: vehicle_details)
  end

  def create(conn, %{"vehicle_detail" => vehicle_detail_params}) do
    with {:ok, %VehicleDetail{} = vehicle_detail} <- Core.create_vehicle_detail(vehicle_detail_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", vehicle_detail_path(conn, :show, vehicle_detail))
      |> render("show.json", vehicle_detail: vehicle_detail)
    end
  end

  def show(conn, %{"id" => id}) do
    vehicle_detail = Core.get_vehicle_detail!(id)
    render(conn, "show.json", vehicle_detail: vehicle_detail)
  end

  def update(conn, %{"id" => id, "vehicle_detail" => vehicle_detail_params}) do
    vehicle_detail = Core.get_vehicle_detail!(id)

    with {:ok, %VehicleDetail{} = vehicle_detail} <- Core.update_vehicle_detail(vehicle_detail, vehicle_detail_params) do
      render(conn, "show.json", vehicle_detail: vehicle_detail)
    end
  end

  def delete(conn, %{"id" => id}) do
    vehicle_detail = Core.get_vehicle_detail!(id)
    with {:ok, %VehicleDetail{}} <- Core.delete_vehicle_detail(vehicle_detail) do
      send_resp(conn, :no_content, "")
    end
  end
end
