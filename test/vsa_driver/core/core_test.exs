defmodule VsaDriver.CoreTest do
  use VsaDriver.DataCase

  alias VsaDriver.Core

  describe "drivers" do
    alias VsaDriver.Core.Driver

    @valid_attrs %{badge_number: "some badge_number", company: "some company", email: "a@a.com", first_name: "some first_name", frequent: true, hazmat_authorized: true, last_name: "some last_name", license: "1111111", password_confirmation_number: "some password_confirmation_number", password_expires: "2010-04-17 14:00:00.000000Z", phone_number: "some phone_number"}
    @update_attrs %{badge_number: "some updated badge_number", company: "some updated company", email: "some updated email", first_name: "some updated first_name", frequent: false, hazmat_authorized: false, last_name: "some updated last_name", license: "some updated license", password_confirmation_number: "some updated password_confirmation_number", password_expires: "2011-05-18 15:01:01.000000Z", password_hash: "some updated password_hash", phone_number: "some updated phone_number"}
    @invalid_attrs %{badge_number: nil, company: nil, email: nil, first_name: nil, frequent: nil, hazmat_authorized: nil, last_name: nil, license: nil, password_confirmation_number: nil, password_expires: nil, password_hash: nil, phone_number: nil}

    def driver_fixture(attrs \\ %{}) do
      {:ok, driver} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_driver()

      driver
    end

    test "list_drivers/0 returns all drivers" do
      driver = driver_fixture()
      assert Core.list_drivers() == [driver]
    end

    test "list_drivers/1 returns driver by email" do
      driver = driver_fixture()
      assert Core.list_drivers(email: "a@a.com") == driver
    end

    test "list_drivers/1 returns driver by license" do
      driver = driver_fixture()
      assert Core.list_drivers(license: "1111111") == driver
    end

    test "get_driver!/1 returns the driver with given id" do
      driver = driver_fixture()
      assert Core.get_driver!(driver.id) == driver
    end

    test "create_driver/1 with valid data creates a driver" do
      assert {:ok, %Driver{} = driver} = Core.create_driver(@valid_attrs)
      assert driver.badge_number == "some badge_number"
      assert driver.company == "some company"
      assert driver.email == "a@a.com"
      assert driver.first_name == "some first_name"
      assert driver.frequent == true
      assert driver.hazmat_authorized == true
      assert driver.last_name == "some last_name"
      assert driver.license == "1111111"
      assert driver.password_confirmation_number == "some password_confirmation_number"
      assert driver.password_expires == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert driver.phone_number == "some phone_number"
    end

    test "create_driver/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_driver(@invalid_attrs)
    end

    test "update_driver/2 with valid data updates the driver" do
      driver = driver_fixture()
      assert {:ok, driver} = Core.update_driver(driver, @update_attrs)
      assert %Driver{} = driver
      assert driver.badge_number == "some updated badge_number"
      assert driver.company == "some updated company"
      assert driver.email == "some updated email"
      assert driver.first_name == "some updated first_name"
      assert driver.frequent == false
      assert driver.hazmat_authorized == false
      assert driver.last_name == "some updated last_name"
      assert driver.license == "some updated license"
      assert driver.password_confirmation_number == "some updated password_confirmation_number"
      assert driver.password_expires == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert driver.phone_number == "some updated phone_number"
    end

    test "update_driver/2 with invalid data returns error changeset" do
      driver = driver_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_driver(driver, @invalid_attrs)
      assert driver == Core.get_driver!(driver.id)
    end

    test "delete_driver/1 deletes the driver" do
      driver = driver_fixture()
      assert {:ok, %Driver{}} = Core.delete_driver(driver)
      assert_raise Ecto.NoResultsError, fn -> Core.get_driver!(driver.id) end
    end

    test "change_driver/1 returns a driver changeset" do
      driver = driver_fixture()
      assert %Ecto.Changeset{} = Core.change_driver(driver)
    end
  end

  describe "vehicle_details" do
    alias VsaDriver.Core.VehicleDetail

    @valid_attrs %{seals: true, sleeper_cab: true, trailer_length: 42, turn_radius: 42, vehicle_type: "some vehicle_type"}
    @update_attrs %{seals: false, sleeper_cab: false, trailer_length: 43, turn_radius: 43, vehicle_type: "some updated vehicle_type"}
    @invalid_attrs %{seals: nil, sleeper_cab: nil, trailer_length: nil, turn_radius: nil, vehicle_type: nil}

    def vehicle_detail_fixture(attrs \\ %{}) do
      {:ok, vehicle_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_vehicle_detail()

      vehicle_detail
    end

    test "list_vehicle_details/0 returns all vehicle_details" do
      vehicle_detail = vehicle_detail_fixture()
      assert Core.list_vehicle_details() == [vehicle_detail]
    end

    test "get_vehicle_detail!/1 returns the vehicle_detail with given id" do
      vehicle_detail = vehicle_detail_fixture()
      assert Core.get_vehicle_detail!(vehicle_detail.id) == vehicle_detail
    end

    test "create_vehicle_detail/1 with valid data creates a vehicle_detail" do
      assert {:ok, %VehicleDetail{} = vehicle_detail} = Core.create_vehicle_detail(@valid_attrs)
      assert vehicle_detail.seals == true
      assert vehicle_detail.sleeper_cab == true
      assert vehicle_detail.trailer_length == 42
      assert vehicle_detail.turn_radius == 42
      assert vehicle_detail.vehicle_type == "some vehicle_type"
    end

    test "create_vehicle_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_vehicle_detail(@invalid_attrs)
    end

    test "update_vehicle_detail/2 with valid data updates the vehicle_detail" do
      vehicle_detail = vehicle_detail_fixture()
      assert {:ok, vehicle_detail} = Core.update_vehicle_detail(vehicle_detail, @update_attrs)
      assert %VehicleDetail{} = vehicle_detail
      assert vehicle_detail.seals == false
      assert vehicle_detail.sleeper_cab == false
      assert vehicle_detail.trailer_length == 43
      assert vehicle_detail.turn_radius == 43
      assert vehicle_detail.vehicle_type == "some updated vehicle_type"
    end

    test "update_vehicle_detail/2 with invalid data returns error changeset" do
      vehicle_detail = vehicle_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_vehicle_detail(vehicle_detail, @invalid_attrs)
      assert vehicle_detail == Core.get_vehicle_detail!(vehicle_detail.id)
    end

    test "delete_vehicle_detail/1 deletes the vehicle_detail" do
      vehicle_detail = vehicle_detail_fixture()
      assert {:ok, %VehicleDetail{}} = Core.delete_vehicle_detail(vehicle_detail)
      assert_raise Ecto.NoResultsError, fn -> Core.get_vehicle_detail!(vehicle_detail.id) end
    end

    test "change_vehicle_detail/1 returns a vehicle_detail changeset" do
      vehicle_detail = vehicle_detail_fixture()
      assert %Ecto.Changeset{} = Core.change_vehicle_detail(vehicle_detail)
    end
  end

  describe "workorder_details" do
    alias VsaDriver.Core.WorkorderDetail

    @valid_attrs %{cargo_content: "some cargo_content", poc_extention: "some poc_extention", poc_name: "some poc_name", poc_phone: "some poc_phone"}
    @update_attrs %{cargo_content: "some updated cargo_content", poc_extention: "some updated poc_extention", poc_name: "some updated poc_name", poc_phone: "some updated poc_phone"}
    @invalid_attrs %{cargo_content: nil, poc_extention: nil, poc_name: nil, poc_phone: nil}

    def workorder_detail_fixture(attrs \\ %{}) do
      {:ok, workorder_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_workorder_detail()

      workorder_detail
    end

    test "list_workorder_details/0 returns all workorder_details" do
      workorder_detail = workorder_detail_fixture()
      assert Core.list_workorder_details() == [workorder_detail]
    end

    test "get_workorder_detail!/1 returns the workorder_detail with given id" do
      workorder_detail = workorder_detail_fixture()
      assert Core.get_workorder_detail!(workorder_detail.id) == workorder_detail
    end

    test "create_workorder_detail/1 with valid data creates a workorder_detail" do
      assert {:ok, %WorkorderDetail{} = workorder_detail} = Core.create_workorder_detail(@valid_attrs)
      assert workorder_detail.cargo_content == "some cargo_content"
      assert workorder_detail.poc_extention == "some poc_extention"
      assert workorder_detail.poc_name == "some poc_name"
      assert workorder_detail.poc_phone == "some poc_phone"
    end

    test "create_workorder_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_workorder_detail(@invalid_attrs)
    end

    test "update_workorder_detail/2 with valid data updates the workorder_detail" do
      workorder_detail = workorder_detail_fixture()
      assert {:ok, workorder_detail} = Core.update_workorder_detail(workorder_detail, @update_attrs)
      assert %WorkorderDetail{} = workorder_detail
      assert workorder_detail.cargo_content == "some updated cargo_content"
      assert workorder_detail.poc_extention == "some updated poc_extention"
      assert workorder_detail.poc_name == "some updated poc_name"
      assert workorder_detail.poc_phone == "some updated poc_phone"
    end

    test "update_workorder_detail/2 with invalid data returns error changeset" do
      workorder_detail = workorder_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_workorder_detail(workorder_detail, @invalid_attrs)
      assert workorder_detail == Core.get_workorder_detail!(workorder_detail.id)
    end

    test "delete_workorder_detail/1 deletes the workorder_detail" do
      workorder_detail = workorder_detail_fixture()
      assert {:ok, %WorkorderDetail{}} = Core.delete_workorder_detail(workorder_detail)
      assert_raise Ecto.NoResultsError, fn -> Core.get_workorder_detail!(workorder_detail.id) end
    end

    test "change_workorder_detail/1 returns a workorder_detail changeset" do
      workorder_detail = workorder_detail_fixture()
      assert %Ecto.Changeset{} = Core.change_workorder_detail(workorder_detail)
    end
  end
end
