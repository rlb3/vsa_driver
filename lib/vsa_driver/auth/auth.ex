defmodule VsaDriver.Auth do
  import Ecto.Query, warn: false
  alias VsaDriver.Repo
  alias VsaDriver.Core.{Driver}
  import Joken

  @moduledoc false

  @eight_hours 28_800
  @token_secret Application.get_env(:vsa_driver, VsaDriverWeb.Endpoint)[:secret_key_base]

  def create_session(%{email: email, password: password}) do
    driver =
      Driver
      |> Repo.get_by!(email: email)

    case Comeonin.Argon2.check_pass(driver, password) do
      {:ok, %Driver{}} ->
        token =
          %{type: "driver", id: driver.id}
          |> token
          |> with_exp(@eight_hours)
          |> with_signer(hs256(@token_secret))
          |> sign
          |> get_compact

        {:ok, token}

      {:error, _message} ->
        {:error, "Invalid email or password"}
    end
  end
end
