defmodule VsaDriver.DriverEmail do
  import Swoosh.Email

  @moduledoc false

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

  def forgot_password(driver) do
    new()
    |> to(driver.email)
    |> from("no-reply@exeloncorp.com")
    |> subject("VSA Password Reset")
    |> html_body(
      "<p>#{driver.first_name} #{driver.last_name},</p><p>  You are recieving this email because you have requested that your password be reset. Please enter the confirmation code #{
        driver.password_confirmation_number
      }    in the Exelon Driver App to continue with changing your password.</p><p>    Thank you,</p><p>    Exelon</p>"
    )
  end
end
