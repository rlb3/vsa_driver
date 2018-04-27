defmodule VsaDriverWeb.Router do
  use VsaDriverWeb, :router

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
    import Joken

    case Plug.Conn.get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        user =
          token
          |> token
          |> with_signer(hs256("my_secret"))
          |> verify
          |> case do
            %{claims: %{"id" => id}} ->
              VsaDriver.Core.get_driver!(id)

            _ ->
              nil
          end

        case user do
          %VsaDriver.Core.Driver{} ->
            %{conn | assigns: Map.put(conn.assigns, :current_user, user)}

          _ ->
            conn
        end

      [] ->
        conn
    end
  end
end
