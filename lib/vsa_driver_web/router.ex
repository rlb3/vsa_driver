defmodule VsaDriverWeb.Router do
  use VsaDriverWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(VsaDriverWeb.Auth)
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
end
