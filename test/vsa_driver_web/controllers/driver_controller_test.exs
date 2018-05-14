defmodule VsaDriverWeb.DriverControllerTest do
  use VsaDriverWeb.ConnCase

  alias VsaDriver.{Core, Repo, Auth}
  alias VsaDriver.Core.Driver

  @moduledoc false

  @valid_attrs %{data: %{attributes: %{badge_number: "some badge_number", company: "some company", email: "a@a.com", first_name: "some first_name", frequent: true, hazmat_authorized: true, last_name: "some last_name", license: "1111111", password_confirmation_number: "some password_confirmation_number", password_expires: "2010-04-17 14:00:00.000000Z", phone_number: "some phone_number", password: "0123456789", password_confirmation: "0123456789", confirmed: true}}}

  def keys_to_string(params) do
    for {key, value} <- params, into: %{}, do: {Atom.to_string(key), value}
  end

  def driver_fixture(%{data: %{attributes: attrs}} \\ %{}) do
    with {:ok, driver} <- attrs |> keys_to_string |> Core.create_driver(),
         {:ok, token} <- Auth.create_session(%{email: "a@a.com", password: "0123456789"}) do
      {driver, token}
    end
  end

  test "create driver", %{conn: conn} do
    %{"data" => %{"attributes" => %{"password-confirmation-number" => code}}} = conn
    |> post(driver_path(conn, :create), @valid_attrs)
    |> json_response(201)

    driver = Driver
    |> Repo.get_by(password_confirmation_number: code)

    assert driver.email == "a@a.com"
  end

  test "find driver by email", %{conn: conn} do
    {driver, token} = driver_fixture(@valid_attrs)
    driver |> Driver.changeset(%{"confirmed" => true}) |> Repo.update!

    email = "a@a.com"
    response = conn
    |> put_req_header("authorization", "Bearer #{token}")
    |> get(driver_path(conn, :index), %{filter: %{email: email}})
    |> json_response(200)

    assert get_in(response, ["data", "attributes", "email"]) == email
  end

  test "find driver by license", %{conn: conn} do
    {driver, token} = driver_fixture(@valid_attrs)
    driver |> Driver.changeset(%{"confirmed" => true}) |> Repo.update!

    license = "1111111"
    response = conn
    |> put_req_header("authorization", "Bearer #{token}")
    |> get(driver_path(conn, :index), %{filter: %{license: license}})
    |> json_response(200)

    assert get_in(response, ["data", "attributes", "license"]) == license
  end

  test "get current user", %{conn: conn} do
    {driver, token} = driver_fixture(@valid_attrs)
    driver |> Driver.changeset(%{"confirmed" => true}) |> Repo.update!

    response = conn
    |> put_req_header("authorization", "Bearer #{token}")
    |> get(driver_path(conn, :me))
    |> json_response(200)

    assert get_in(response, ["data", "id"]) == Integer.to_string(driver.id)
  end
end
