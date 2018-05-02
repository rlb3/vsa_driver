defmodule VsaDriverWeb.DriverController do
  use VsaDriverWeb, :controller

  alias VsaDriver.Core
  alias VsaDriver.Core.Driver

  action_fallback(VsaDriverWeb.FallbackController)

  def me(conn, _params) do
    case conn.assigns[:current_user] do
      %Driver{} = driver ->
        render(conn, "show.json-api", data: driver)

      _ ->
        conn
    end
  end

  def index(conn, %{"filter" => %{"email" => email}}) do
    drivers = Core.list_drivers(email: email)
    render(conn, "index.json-api", data: drivers)
  end

  def index(conn, %{"filter" => %{"license" => license}}) do
    drivers = Core.list_drivers(license: license)
    render(conn, "index.json-api", data: drivers)
  end

  def create(conn, %{"data" => data}) do
    driver_params = JaSerializer.Params.to_attributes(data)

    with {:ok, %Driver{} = driver} <- Core.create_driver(driver_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", driver_path(conn, :show, driver))
      |> render("show.json-api", data: driver)
    end
  end

  def show(conn, %{"id" => id}) do
    driver = Core.get_driver!(id)
    render(conn, "show.json-api", data: driver)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    driver_params = JaSerializer.Params.to_attributes(data)
    driver = Core.get_driver!(id)
    # driver = case driver_params do
    #   %{email: email} -> Core.get_driver!(email: email)
    #   %{license: license} -> Core.get_driver!(license: license)
    #   _ ->
    # end

    with {:ok, %Driver{} = driver} <- Core.update_driver(driver, driver_params) do
      render(conn, "show.json-api", data: driver)
    end
  end

  def delete(conn, %{"id" => id}) do
    driver = Core.get_driver!(id)

    with {:ok, %Driver{}} <- Core.delete_driver(driver) do
      render(conn, "show.json-api", data: driver)
    end
  end

  def confirm(conn, %{"data" => data}) do
    %{"confirmation" => code} = JaSerializer.Params.to_attributes(data)

    driver = Core.confirm_driver(%{password_confirmation_number: code})

    render(conn, "show.json-api", data: driver)
  end
end
