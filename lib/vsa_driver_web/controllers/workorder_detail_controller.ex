defmodule VsaDriverWeb.WorkorderDetailController do
  use VsaDriverWeb, :controller

  alias VsaDriver.Core
  alias VsaDriver.Core.WorkorderDetail

  action_fallback(VsaDriverWeb.FallbackController)

  def index(conn, _params) do
    workorder_details = Core.list_workorder_details()
    render(conn, "index.json", workorder_details: workorder_details)
  end

  def create(conn, %{"workorder_detail" => workorder_detail_params}) do
    with {:ok, %WorkorderDetail{} = workorder_detail} <-
           Core.create_workorder_detail(workorder_detail_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", workorder_detail_path(conn, :show, workorder_detail))
      |> render("show.json", workorder_detail: workorder_detail)
    end
  end

  def show(conn, %{"id" => id}) do
    workorder_detail = Core.get_workorder_detail!(id)
    render(conn, "show.json", workorder_detail: workorder_detail)
  end

  def update(conn, %{"id" => id, "workorder_detail" => workorder_detail_params}) do
    workorder_detail = Core.get_workorder_detail!(id)

    with {:ok, %WorkorderDetail{} = workorder_detail} <-
           Core.update_workorder_detail(workorder_detail, workorder_detail_params) do
      render(conn, "show.json", workorder_detail: workorder_detail)
    end
  end

  def delete(conn, %{"id" => id}) do
    workorder_detail = Core.get_workorder_detail!(id)

    with {:ok, %WorkorderDetail{}} <- Core.delete_workorder_detail(workorder_detail) do
      send_resp(conn, :no_content, "")
    end
  end
end
