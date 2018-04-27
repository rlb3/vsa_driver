defmodule VsaDriverWeb.Router do
  use VsaDriverWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(JaSerializer.Deserializer)
  end

  scope "/api", VsaDriverWeb do
    pipe_through(:api)

    resources("/drivers", DriverController, except: [:new, :edit]) do
      resources("/vehicle_details", VehicleDetailController, except: [:new, :edit])
      resources("/workorder_details", WorkorderDetailController, except: [:new, :edit])
    end
  end
end
