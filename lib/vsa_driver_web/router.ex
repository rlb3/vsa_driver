defmodule VsaDriverWeb.Router do
  use VsaDriverWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", VsaDriverWeb do
    pipe_through :api
  end
end
