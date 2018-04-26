defmodule VsaDriverWeb.DriverController do
  use VsaDriverWeb, :controller

  alias VsaDriver.Core
  alias VsaDriver.Core.Driver

  action_fallback(VsaDriverWeb.FallbackController)

  def index(conn, _params) do
    drivers = Core.list_drivers()
    render(conn, "index.json-api", data: drivers)
  end

  def create(conn, %{"driver" => driver_params}) do
    with {:ok, %Driver{} = driver} <- Core.create_driver(driver_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", driver_path(conn, :show, driver))
      |> render("show.json", driver: driver)
    end
  end

  def show(conn, %{"id" => id}) do
    driver = Core.get_driver!(id)
    render(conn, "show.json", driver: driver)
  end

  def update(conn, %{"id" => id, "driver" => driver_params}) do
    driver = Core.get_driver!(id)

    with {:ok, %Driver{} = driver} <- Core.update_driver(driver, driver_params) do
      render(conn, "show.json", driver: driver)
    end
  end

  def delete(conn, %{"id" => id}) do
    driver = Core.get_driver!(id)

    with {:ok, %Driver{}} <- Core.delete_driver(driver) do
      send_resp(conn, :no_content, "")
    end
  end
end
