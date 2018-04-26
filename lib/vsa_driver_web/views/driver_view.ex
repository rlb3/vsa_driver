defmodule VsaDriverWeb.DriverView do
  use VsaDriverWeb, :view
  alias VsaDriverWeb.DriverView

  def render("index.json", %{drivers: drivers}) do
    %{data: render_many(drivers, DriverView, "driver.json")}
  end

  def render("show.json", %{driver: driver}) do
    %{data: render_one(driver, DriverView, "driver.json")}
  end

  def render("driver.json", %{driver: driver}) do
    %{id: driver.id,
      email: driver.email,
      license: driver.license,
      first_name: driver.first_name,
      last_name: driver.last_name,
      phone_number: driver.phone_number,
      company: driver.company,
      hazmat_authorized: driver.hazmat_authorized,
      frequent: driver.frequent,
      badge_number: driver.badge_number,
      password_hash: driver.password_hash,
      password_expires: driver.password_expires,
      password_confirmation_number: driver.password_confirmation_number}
  end
end
