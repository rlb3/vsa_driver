defmodule VsaDriverWeb.SessionController do
  use VsaDriverWeb, :controller

  alias VsaDriver.Auth

  action_fallback VsaDriverWeb.FallbackController

  def create(conn, %{"data" => data}) do
    %{"email" =>  email, "password" =>  password} = JaSerializer.Params.to_attributes(data)
    with {:ok, token} <- Auth.create_session(%{email: email, password: password}) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: %{token: token})
    end
  end
end
