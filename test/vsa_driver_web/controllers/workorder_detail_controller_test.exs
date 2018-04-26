defmodule VsaDriverWeb.WorkorderDetailControllerTest do
  use VsaDriverWeb.ConnCase

  alias VsaDriver.Core
  alias VsaDriver.Core.WorkorderDetail

  @create_attrs %{cargo_content: "some cargo_content", poc_extention: "some poc_extention", poc_name: "some poc_name", poc_phone: "some poc_phone"}
  @update_attrs %{cargo_content: "some updated cargo_content", poc_extention: "some updated poc_extention", poc_name: "some updated poc_name", poc_phone: "some updated poc_phone"}
  @invalid_attrs %{cargo_content: nil, poc_extention: nil, poc_name: nil, poc_phone: nil}

  def fixture(:workorder_detail) do
    {:ok, workorder_detail} = Core.create_workorder_detail(@create_attrs)
    workorder_detail
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workorder_details", %{conn: conn} do
      conn = get conn, workorder_detail_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workorder_detail" do
    test "renders workorder_detail when data is valid", %{conn: conn} do
      conn = post conn, workorder_detail_path(conn, :create), workorder_detail: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, workorder_detail_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "cargo_content" => "some cargo_content",
        "poc_extention" => "some poc_extention",
        "poc_name" => "some poc_name",
        "poc_phone" => "some poc_phone"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, workorder_detail_path(conn, :create), workorder_detail: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workorder_detail" do
    setup [:create_workorder_detail]

    test "renders workorder_detail when data is valid", %{conn: conn, workorder_detail: %WorkorderDetail{id: id} = workorder_detail} do
      conn = put conn, workorder_detail_path(conn, :update, workorder_detail), workorder_detail: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, workorder_detail_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "cargo_content" => "some updated cargo_content",
        "poc_extention" => "some updated poc_extention",
        "poc_name" => "some updated poc_name",
        "poc_phone" => "some updated poc_phone"}
    end

    test "renders errors when data is invalid", %{conn: conn, workorder_detail: workorder_detail} do
      conn = put conn, workorder_detail_path(conn, :update, workorder_detail), workorder_detail: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workorder_detail" do
    setup [:create_workorder_detail]

    test "deletes chosen workorder_detail", %{conn: conn, workorder_detail: workorder_detail} do
      conn = delete conn, workorder_detail_path(conn, :delete, workorder_detail)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, workorder_detail_path(conn, :show, workorder_detail)
      end
    end
  end

  defp create_workorder_detail(_) do
    workorder_detail = fixture(:workorder_detail)
    {:ok, workorder_detail: workorder_detail}
  end
end
