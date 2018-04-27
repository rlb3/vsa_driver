defmodule VsaDriverWeb.Router do
  use VsaDriverWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:auth)
    plug(JaSerializer.Deserializer)
  end

  scope "/api", VsaDriverWeb do
    pipe_through(:api)

    resources "/sessions", SessionController, only: [:create]
    resources("/drivers", DriverController, except: [:new, :edit]) do
      resources("/vehicle_details", VehicleDetailController, except: [:new, :edit])
      resources("/workorder_details", WorkorderDetailController, except: [:new, :edit])
    end
  end

  defp auth(conn, _opt) do
    user = conn
    |> get_req_header("authorization")
    |> user_from_token

    %{conn | assigns: Map.put(conn.assigns, :current_user, user)}
  end

  defp user_from_token(["Bearer " <> token]) do
    import Joken

    token
    |> token
    |> with_signer(hs256("my_secret"))
    |> verify
    |> case do
         %{claims: %{"id" => id}} ->
           VsaDriver.Core.get_driver!(id)
         _ -> nil
       end
  end
end
