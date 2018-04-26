defmodule VsaDriverWeb.DriverControllerTest do
  use VsaDriverWeb.ConnCase

  alias VsaDriver.Core
  alias VsaDriver.Core.Driver

  @create_attrs %{badge_number: "some badge_number", company: "some company", email: "some email", first_name: "some first_name", frequent: true, hazmat_authorized: true, last_name: "some last_name", license: "some license", password_confirmation_number: "some password_confirmation_number", password_expires: "2010-04-17 14:00:00.000000Z", password_hash: "some password_hash", phone_number: "some phone_number"}
  @update_attrs %{badge_number: "some updated badge_number", company: "some updated company", email: "some updated email", first_name: "some updated first_name", frequent: false, hazmat_authorized: false, last_name: "some updated last_name", license: "some updated license", password_confirmation_number: "some updated password_confirmation_number", password_expires: "2011-05-18 15:01:01.000000Z", password_hash: "some updated password_hash", phone_number: "some updated phone_number"}
  @invalid_attrs %{badge_number: nil, company: nil, email: nil, first_name: nil, frequent: nil, hazmat_authorized: nil, last_name: nil, license: nil, password_confirmation_number: nil, password_expires: nil, password_hash: nil, phone_number: nil}

  def fixture(:driver) do
    {:ok, driver} = Core.create_driver(@create_attrs)
    driver
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all drivers", %{conn: conn} do
      conn = get conn, driver_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create driver" do
    test "renders driver when data is valid", %{conn: conn} do
      conn = post conn, driver_path(conn, :create), driver: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, driver_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "badge_number" => "some badge_number",
        "company" => "some company",
        "email" => "some email",
        "first_name" => "some first_name",
        "frequent" => true,
        "hazmat_authorized" => true,
        "last_name" => "some last_name",
        "license" => "some license",
        "password_confirmation_number" => "some password_confirmation_number",
        "password_expires" => "2010-04-17 14:00:00.000000Z",
        "password_hash" => "some password_hash",
        "phone_number" => "some phone_number"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, driver_path(conn, :create), driver: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update driver" do
    setup [:create_driver]

    test "renders driver when data is valid", %{conn: conn, driver: %Driver{id: id} = driver} do
      conn = put conn, driver_path(conn, :update, driver), driver: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, driver_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "badge_number" => "some updated badge_number",
        "company" => "some updated company",
        "email" => "some updated email",
        "first_name" => "some updated first_name",
        "frequent" => false,
        "hazmat_authorized" => false,
        "last_name" => "some updated last_name",
        "license" => "some updated license",
        "password_confirmation_number" => "some updated password_confirmation_number",
        "password_expires" => "2011-05-18 15:01:01.000000Z",
        "password_hash" => "some updated password_hash",
        "phone_number" => "some updated phone_number"}
    end

    test "renders errors when data is invalid", %{conn: conn, driver: driver} do
      conn = put conn, driver_path(conn, :update, driver), driver: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete driver" do
    setup [:create_driver]

    test "deletes chosen driver", %{conn: conn, driver: driver} do
      conn = delete conn, driver_path(conn, :delete, driver)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, driver_path(conn, :show, driver)
      end
    end
  end

  defp create_driver(_) do
    driver = fixture(:driver)
    {:ok, driver: driver}
  end
end
