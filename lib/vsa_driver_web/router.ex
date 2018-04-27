defmodule VsaDriverWeb.Router do
  use VsaDriverWeb, :router
  @token_secret Application.get_env(:vsa_driver, VsaDriverWeb.Endpoint)[:secret_key_base]

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:auth)
    plug(JaSerializer.Deserializer)
  end

  scope "/api", VsaDriverWeb do
    pipe_through(:api)

    resources("/sessions", SessionController, only: [:create])

    get "/drivers/me", DriverController, :me
    resources("/drivers", DriverController, except: [:new, :edit]) do
      resources("/vehicle_details", VehicleDetailController, except: [:new, :edit])
      resources("/workorder_details", WorkorderDetailController, except: [:new, :edit])
    end
  end

  defp auth(conn, _opt) do
    conn
    |> user_from_token
  end

  def user_from_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case get_user(token) do
          %VsaDriver.Core.Driver{} = user ->
            %{conn | assigns: Map.put(conn.assigns, :current_user, user)}

          _ ->
            conn
        end

      [] ->
        conn
    end
  end

  def get_user(token) do
    import Joken

    token
    |> token
    |> with_signer(hs256(@token_secret))
    |> verify
    |> case do
         %{claims: %{"id" => id}} ->
           VsaDriver.Core.get_driver!(id)

         _ ->
           nil
       end
  end
end
