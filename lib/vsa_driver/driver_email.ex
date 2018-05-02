defmodule VsaDriver.DriverEmail do
  import Swoosh.Email

  def confirmation_email(driver) do
    new()
    |> to(driver.email)
    |> from("no-reply@exeloncorp.com")
    |> subject("VSA Password Confirmation")
    |> html_body(
      "<p>#{driver.first_name} #{driver.last_name},</p><p>    You are receiving this email because you have created a new account. Please enter the confirmation code #{
        driver.password_confirmation_number
      } in the Exelon Driver App to confirm your account.</p><p>    Thank you,</p><p>    Exelon</p>"
    )
  end
end
