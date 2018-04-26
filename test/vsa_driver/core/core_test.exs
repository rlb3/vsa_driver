defmodule VsaDriver.CoreTest do
  use VsaDriver.DataCase

  alias VsaDriver.Core

  describe "drivers" do
    alias VsaDriver.Core.Driver

    @valid_attrs %{badge_number: "some badge_number", company: "some company", email: "some email", first_name: "some first_name", frequent: true, hazmat_authorized: true, last_name: "some last_name", license: "some license", password_confirmation_number: "some password_confirmation_number", password_expires: "2010-04-17 14:00:00.000000Z", password_hash: "some password_hash", phone_number: "some phone_number"}
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

    test "get_driver!/1 returns the driver with given id" do
      driver = driver_fixture()
      assert Core.get_driver!(driver.id) == driver
    end

    test "create_driver/1 with valid data creates a driver" do
      assert {:ok, %Driver{} = driver} = Core.create_driver(@valid_attrs)
      assert driver.badge_number == "some badge_number"
      assert driver.company == "some company"
      assert driver.email == "some email"
      assert driver.first_name == "some first_name"
      assert driver.frequent == true
      assert driver.hazmat_authorized == true
      assert driver.last_name == "some last_name"
      assert driver.license == "some license"
      assert driver.password_confirmation_number == "some password_confirmation_number"
      assert driver.password_expires == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert driver.password_hash == "some password_hash"
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
      assert driver.password_hash == "some updated password_hash"
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
end
