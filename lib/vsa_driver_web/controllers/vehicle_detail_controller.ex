defmodule VsaDriverWeb.VehicleDetailController do
  use VsaDriverWeb, :controller

  alias VsaDriver.Core
  alias VsaDriver.Core.VehicleDetail

  plug(VsaDriverWeb.Authorization)

  action_fallback(VsaDriverWeb.FallbackController)

  def index(conn, _params) do
    vehicle_details = Core.list_vehicle_details(conn.assigns.current_driver)
    render(conn, "index.json-api", data: vehicle_details)
  end

  def create(conn, %{"data" => data}) do
    vehicle_detail_params = JaSerializer.Params.to_attributes(data)

    with {:ok, %VehicleDetail{} = vehicle_detail} <-
           Core.create_vehicle_detail(conn.assigns.current_driver, vehicle_detail_params) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: vehicle_detail)
    end
  end

  def update(conn, %{"id" => id, "data" => data}) do
    vehicle_detail_params = JaSerializer.Params.to_attributes(data)
    vehicle_detail = Core.get_vehicle_detail!(conn.assigns.current_driver, id)

    with {:ok, %VehicleDetail{} = vehicle_detail} <-
           Core.update_vehicle_detail(vehicle_detail, vehicle_detail_params) do
      render(conn, "show.json-api", data: vehicle_detail)
    end
  end

  def delete(conn, %{"id" => id}) do
    vehicle_detail = Core.get_vehicle_detail!(conn.assigns.current_driver, id)

    with {:ok, %VehicleDetail{}} <- Core.delete_vehicle_detail(vehicle_detail) do
      send_resp(conn, :no_content, "")
    end
  end
end
