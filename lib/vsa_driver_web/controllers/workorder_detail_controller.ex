defmodule VsaDriverWeb.WorkorderDetailController do
  use VsaDriverWeb, :controller

  alias VsaDriver.Core
  alias VsaDriver.Core.WorkorderDetail

  action_fallback(VsaDriverWeb.FallbackController)

  def index(conn, _params) do
    workorder_details = Core.list_workorder_details(conn.assigns.current_driver)
    render(conn, "index.json-api", data: workorder_details)
  end

  def create(conn, %{"data" => data}) do
    workorder_detail_params = JaSerializer.Params.to_attributes(data)

    with {:ok, %WorkorderDetail{} = workorder_detail} <-
           Core.create_workorder_detail(conn.assigns.current_driver, workorder_detail_params) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: workorder_detail)
    end
  end

  def update(conn, %{"id" => id, "data" => data}) do
    workorder_detail_params = JaSerializer.Params.to_attributes(data)
    workorder_detail = Core.get_workorder_detail!(conn.assigns.current_driver, id)

    with {:ok, %WorkorderDetail{} = workorder_detail} <-
           Core.update_workorder_detail(workorder_detail, workorder_detail_params) do
      render(conn, "show.json", workorder_detail: workorder_detail)
    end
  end

  def delete(conn, %{"id" => id}) do
    workorder_detail = Core.get_workorder_detail!(conn.assigns.current_driver, id)

    with {:ok, %WorkorderDetail{}} <- Core.delete_workorder_detail(workorder_detail) do
      send_resp(conn, :no_content, "")
    end
  end
end
