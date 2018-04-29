defmodule VsaDriver.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias VsaDriver.Repo

  alias VsaDriver.Core.Driver

  @doc """
  Returns the list of drivers.

  ## Examples

      iex> list_drivers()
      [%Driver{}, ...]

  """

  def list_drivers do
    Driver |> Repo.all()
  end

  @doc """
  Returns a driver by email.

  ## Examples

  iex> list_drivers(email: email)
  %Driver{}
  """

  def list_drivers(email: email) do
    query = from(d in Driver, where: d.email == ^email)
    query |> Repo.one() 
  end

  @doc """
  Returns a driver by driver's license.

  ## Examples

  iex> list_drivers(license: license)
  %Driver{}
  """

  def list_drivers(license: license) do
    query = from(d in Driver, where: d.license == ^license)
    query |> Repo.one()
  end

  @doc """
  Gets a single driver.

  Raises `Ecto.NoResultsError` if the Driver does not exist.

  ## Examples

      iex> get_driver!(123)
      %Driver{}

      iex> get_driver!(456)
      ** (Ecto.NoResultsError)

  """
  def get_driver!(id), do: Repo.get!(Driver, id)

  # def get_driver!(email: email) do
  #   Repo.get_by!(Driver, email: email)
  # end

  # def get_driver!(license: license) do
  #   Repo.get_by!(Driver, license: license)
  # end

  @doc """
  Creates a driver.

  ## Examples

      iex> create_driver(%{field: value})
      {:ok, %Driver{}}

      iex> create_driver(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_driver(attrs \\ %{}) do
    %Driver{}
    |> Driver.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a driver.

  ## Examples

      iex> update_driver(driver, %{field: new_value})
      {:ok, %Driver{}}

      iex> update_driver(driver, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_driver(%Driver{} = driver, attrs) do
    driver
    |> Driver.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Driver.

  ## Examples

      iex> delete_driver(driver)
      {:ok, %Driver{}}

      iex> delete_driver(driver)
      {:error, %Ecto.Changeset{}}

  """
  def delete_driver(%Driver{} = driver) do
    Repo.delete(driver)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking driver changes.

  ## Examples

      iex> change_driver(driver)
      %Ecto.Changeset{source: %Driver{}}

  """
  def change_driver(%Driver{} = driver) do
    Driver.changeset(driver, %{})
  end

  alias VsaDriver.Core.VehicleDetail

  @doc """
  Returns the list of vehicle_details.

  ## Examples

      iex> list_vehicle_details()
      [%VehicleDetail{}, ...]

  """
  def list_vehicle_details do
    Repo.all(VehicleDetail)
  end

  @doc """
  Gets a single vehicle_detail.

  Raises `Ecto.NoResultsError` if the Vehicle detail does not exist.

  ## Examples

      iex> get_vehicle_detail!(123)
      %VehicleDetail{}

      iex> get_vehicle_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vehicle_detail!(id), do: Repo.get!(VehicleDetail, id)

  @doc """
  Creates a vehicle_detail.

  ## Examples

      iex> create_vehicle_detail(%{field: value})
      {:ok, %VehicleDetail{}}

      iex> create_vehicle_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vehicle_detail(attrs \\ %{}) do
    %VehicleDetail{}
    |> VehicleDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vehicle_detail.

  ## Examples

      iex> update_vehicle_detail(vehicle_detail, %{field: new_value})
      {:ok, %VehicleDetail{}}

      iex> update_vehicle_detail(vehicle_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vehicle_detail(%VehicleDetail{} = vehicle_detail, attrs) do
    vehicle_detail
    |> VehicleDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a VehicleDetail.

  ## Examples

      iex> delete_vehicle_detail(vehicle_detail)
      {:ok, %VehicleDetail{}}

      iex> delete_vehicle_detail(vehicle_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vehicle_detail(%VehicleDetail{} = vehicle_detail) do
    Repo.delete(vehicle_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicle_detail changes.

  ## Examples

      iex> change_vehicle_detail(vehicle_detail)
      %Ecto.Changeset{source: %VehicleDetail{}}

  """
  def change_vehicle_detail(%VehicleDetail{} = vehicle_detail) do
    VehicleDetail.changeset(vehicle_detail, %{})
  end

  alias VsaDriver.Core.WorkorderDetail

  @doc """
  Returns the list of workorder_details.

  ## Examples

      iex> list_workorder_details()
      [%WorkorderDetail{}, ...]

  """
  def list_workorder_details do
    Repo.all(WorkorderDetail)
  end

  @doc """
  Gets a single workorder_detail.

  Raises `Ecto.NoResultsError` if the Workorder detail does not exist.

  ## Examples

      iex> get_workorder_detail!(123)
      %WorkorderDetail{}

      iex> get_workorder_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workorder_detail!(id), do: Repo.get!(WorkorderDetail, id)

  @doc """
  Creates a workorder_detail.

  ## Examples

      iex> create_workorder_detail(%{field: value})
      {:ok, %WorkorderDetail{}}

      iex> create_workorder_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workorder_detail(attrs \\ %{}) do
    %WorkorderDetail{}
    |> WorkorderDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workorder_detail.

  ## Examples

      iex> update_workorder_detail(workorder_detail, %{field: new_value})
      {:ok, %WorkorderDetail{}}

      iex> update_workorder_detail(workorder_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workorder_detail(%WorkorderDetail{} = workorder_detail, attrs) do
    workorder_detail
    |> WorkorderDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a WorkorderDetail.

  ## Examples

      iex> delete_workorder_detail(workorder_detail)
      {:ok, %WorkorderDetail{}}

      iex> delete_workorder_detail(workorder_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workorder_detail(%WorkorderDetail{} = workorder_detail) do
    Repo.delete(workorder_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workorder_detail changes.

  ## Examples

      iex> change_workorder_detail(workorder_detail)
      %Ecto.Changeset{source: %WorkorderDetail{}}

  """
  def change_workorder_detail(%WorkorderDetail{} = workorder_detail) do
    WorkorderDetail.changeset(workorder_detail, %{})
  end
end
