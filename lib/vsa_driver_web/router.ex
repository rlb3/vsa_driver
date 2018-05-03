defmodule VsaDriverWeb.Router do
  use VsaDriverWeb, :router
  @token_secret

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:auth)
    plug(JaSerializer.Deserializer)
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through([:browser])

      forward("/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox")
    end
  end

  scope "/api", VsaDriverWeb do
    pipe_through(:api)

    resources("/sessions", SessionController, only: [:create])

    get("/drivers/me", DriverController, :me)
    post("/drivers/confirm", DriverController, :confirm)
    post("/drivers/update_password", DriverController, :update_password)
    get("/drivers/forgot_password", DriverController, :forgot_password)
    resources("/drivers", DriverController, except: [:new, :edit])
    resources("/vehicle_details", VehicleDetailController, except: [:new, :edit, :show])
    resources("/workorder_details", WorkorderDetailController, except: [:new, :edit, :show])
  end

  defp auth(conn, _opt) do
    conn
    |> driver_from_token
  end

  defp driver_from_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case get_driver(token) do
          %VsaDriver.Core.Driver{} = driver ->
            %{conn | assigns: Map.put(conn.assigns, :current_driver, driver)}

          _ ->
            conn
        end

      [] ->
        conn
    end
  end

  defp get_driver(token) do
    import Joken

    token
    |> token
    |> with_signer(hs256(token_secret))
    |> verify
    |> case do
      %{claims: %{"id" => id}} ->
        VsaDriver.Core.get_driver!(id)

      _ ->
        nil
    end
  end

  def token_secret do
    Application.get_env(:vsa_driver, VsaDriverWeb.Endpoint)[:secret_key_base]
  end
end
