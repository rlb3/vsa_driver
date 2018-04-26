defmodule VsaDriverWeb.DriverSerializer do
  use JaSerializer

  location("/drivers/:id")

  attributes([
    :badge_number,
    :company,
    :email,
    :first_name,
    :frequent,
    :hazmat_authorized,
    :last_name,
    :license,
    :password_confirmation_number,
    :password_expires,
    :phone_number
  ])
end
