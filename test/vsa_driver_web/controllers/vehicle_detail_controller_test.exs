defmodule VsaDriverWeb.VehicleDetailControllerTest do
  use VsaDriverWeb.ConnCase

  alias VsaDriver.Core
  alias VsaDriver.Core.VehicleDetail

  @create_attrs %{seals: true, sleeper_cab: true, trailer_length: 42, turn_radius: 42, vehicle_type: "some vehicle_type"}
  @update_attrs %{seals: false, sleeper_cab: false, trailer_length: 43, turn_radius: 43, vehicle_type: "some updated vehicle_type"}
  @invalid_attrs %{seals: nil, sleeper_cab: nil, trailer_length: nil, turn_radius: nil, vehicle_type: nil}

  def fixture(:vehicle_detail) do
    {:ok, vehicle_detail} = Core.create_vehicle_detail(@create_attrs)
    vehicle_detail
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vehicle_details", %{conn: conn} do
      conn = get conn, vehicle_detail_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create vehicle_detail" do
    test "renders vehicle_detail when data is valid", %{conn: conn} do
      conn = post conn, vehicle_detail_path(conn, :create), vehicle_detail: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, vehicle_detail_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "seals" => true,
        "sleeper_cab" => true,
        "trailer_length" => 42,
        "turn_radius" => 42,
        "vehicle_type" => "some vehicle_type"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, vehicle_detail_path(conn, :create), vehicle_detail: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vehicle_detail" do
    setup [:create_vehicle_detail]

    test "renders vehicle_detail when data is valid", %{conn: conn, vehicle_detail: %VehicleDetail{id: id} = vehicle_detail} do
      conn = put conn, vehicle_detail_path(conn, :update, vehicle_detail), vehicle_detail: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, vehicle_detail_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "seals" => false,
        "sleeper_cab" => false,
        "trailer_length" => 43,
        "turn_radius" => 43,
        "vehicle_type" => "some updated vehicle_type"}
    end

    test "renders errors when data is invalid", %{conn: conn, vehicle_detail: vehicle_detail} do
      conn = put conn, vehicle_detail_path(conn, :update, vehicle_detail), vehicle_detail: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vehicle_detail" do
    setup [:create_vehicle_detail]

    test "deletes chosen vehicle_detail", %{conn: conn, vehicle_detail: vehicle_detail} do
      conn = delete conn, vehicle_detail_path(conn, :delete, vehicle_detail)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, vehicle_detail_path(conn, :show, vehicle_detail)
      end
    end
  end

  defp create_vehicle_detail(_) do
    vehicle_detail = fixture(:vehicle_detail)
    {:ok, vehicle_detail: vehicle_detail}
  end
end
