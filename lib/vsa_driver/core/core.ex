defmodule VsaDriver.Core do
  @moduledoc """
  The Core context.
  """

  alias Ecto.Multi
  import Ecto.Query, warn: false
  alias VsaDriver.Repo

  alias VsaDriver.Core.Driver

  def list_drivers() do
    Driver |> Repo.all()
  end

  def list_drivers(email: email) do
    query = from(d in Driver, where: d.email == ^email)
    query |> Repo.one()
  end

  def list_drivers(license: license) do
    query = from(d in Driver, where: d.license == ^license)
    query |> Repo.one()
  end

  def get_driver!(params) when is_map(params) do
    Repo.get_by!(Driver, params)
  end

  def get_driver!(id), do: Repo.get!(Driver, id)

  # def get_driver!(email: email) do
  #   Repo.get_by!(Driver, email: email)
  # end

  # def get_driver!(license: license) do
  #   Repo.get_by!(Driver, license: license)
  # end

  def create_driver(attrs \\ %{}) do
    params =
      %{password_confirmation_number: random_string(7)}
      |> Enum.into(attrs)

    Multi.new()
    |> Multi.insert(:driver, Driver.registration_changeset(%Driver{}, params))
    |> Multi.run(:email_confirmation, fn %{driver: driver} ->
      driver
      |> VsaDriver.DriverEmail.confirmation_email()
      |> VsaDriver.Mailer.deliver()
    end)
    |> Repo.transaction()
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  def confirm_driver(attrs \\ %{}) do
    attrs
    |> get_driver!()
    |> Driver.confirmation_changeset()
    |> Repo.update!()
  end

  def update_driver(%Driver{} = driver, attrs) do
    driver
    |> Driver.changeset(attrs)
    |> Repo.update()
  end

  def delete_driver(%Driver{} = driver) do
    Repo.delete(driver)
  end

  def change_driver(%Driver{} = driver) do
    Driver.changeset(driver, %{})
  end

  alias VsaDriver.Core.VehicleDetail

  def list_vehicle_details(driver) do
    driver
    |> Ecto.assoc(:vehicle_details)
    |> Repo.all()
  end

  def get_vehicle_detail!(driver, id) do
    query = from(v in VehicleDetail, where: v.driver_id == ^driver.id and v.id == ^id)
    query |> Repo.one()
  end

  def create_vehicle_detail(driver, attrs \\ %{}) do
    driver
    |> Ecto.build_assoc(:vehicle_details)
    |> VehicleDetail.changeset(attrs)
    |> Repo.insert()
  end

  def update_vehicle_detail(%VehicleDetail{} = vehicle_detail, attrs) do
    vehicle_detail
    |> VehicleDetail.changeset(attrs)
    |> Repo.update()
  end

  def delete_vehicle_detail(%VehicleDetail{} = vehicle_detail) do
    Repo.delete(vehicle_detail)
  end

  def change_vehicle_detail(%VehicleDetail{} = vehicle_detail) do
    VehicleDetail.changeset(vehicle_detail, %{})
  end

  alias VsaDriver.Core.WorkorderDetail

  def list_workorder_details(driver) do
    Repo.all(Ecto.assoc(driver, :workorder_details))
  end

  def get_workorder_detail!(driver, id) do
    query = from(v in WorkorderDetail, where: v.driver_id == ^driver.id and v.id == ^id)
    query |> Repo.one()
  end

  def create_workorder_detail(driver, attrs \\ %{}) do
    driver
    |> Ecto.build_assoc(:workorder_details)
    |> WorkorderDetail.changeset(attrs)
    |> Repo.insert()
  end

  def update_workorder_detail(%WorkorderDetail{} = workorder_detail, attrs) do
    workorder_detail
    |> WorkorderDetail.changeset(attrs)
    |> Repo.update()
  end

  def delete_workorder_detail(%WorkorderDetail{} = workorder_detail) do
    Repo.delete(workorder_detail)
  end

  def change_workorder_detail(%WorkorderDetail{} = workorder_detail) do
    WorkorderDetail.changeset(workorder_detail, %{})
  end
end
