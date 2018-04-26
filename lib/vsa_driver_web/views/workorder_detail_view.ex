defmodule VsaDriverWeb.WorkorderDetailView do
  use VsaDriverWeb, :view
  alias VsaDriverWeb.WorkorderDetailView

  def render("index.json", %{workorder_details: workorder_details}) do
    %{data: render_many(workorder_details, WorkorderDetailView, "workorder_detail.json")}
  end

  def render("show.json", %{workorder_detail: workorder_detail}) do
    %{data: render_one(workorder_detail, WorkorderDetailView, "workorder_detail.json")}
  end

  def render("workorder_detail.json", %{workorder_detail: workorder_detail}) do
    %{
      id: workorder_detail.id,
      poc_name: workorder_detail.poc_name,
      poc_phone: workorder_detail.poc_phone,
      poc_extention: workorder_detail.poc_extention,
      cargo_content: workorder_detail.cargo_content
    }
  end
end
