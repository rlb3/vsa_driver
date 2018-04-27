defmodule VsaDriver.Auth do
  import Ecto.Query, warn: false
  alias VsaDriver.Repo
  import Joken

  def create_session(%{email: email, password: password}) do
    driver =
      VsaDriver.Core.Driver
      |> Repo.get_by!(email: email)

    case Comeonin.Argon2.check_pass(driver, password) do
      {:ok, %VsaDriver.Core.Driver{}} ->
        token =
          %{type: 'driver', id: driver.id}
          |> token
          |> with_signer(hs256("my_secret"))
          |> sign
          |> get_compact

        {:ok, token}

      {:error, message} ->
        {:error, "Invalid email or password"}
    end
  end
end
