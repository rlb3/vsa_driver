defmodule VsaDriverWeb.Auth do
  import Plug.Conn

  def init(opt) do
    opt
  end

  def call(conn, _opt) do
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
            case check_role(token) do
              true ->
                %{conn | assigns: Map.put(conn.assigns, :is_role, true)}

              _ ->
                conn
            end
        end

      [] ->
        conn
    end
  end

  defp check_role(token) do
    import Joken

    token
    |> token
    |> with_signer(hs256(token_secret))
    |> verify
    |> case do
      %{claims: %{"type" => "role"}} ->
        true

      claims ->
        nil
    end
  end

  defp get_driver(token) do
    import Joken

    token
    |> token
    |> with_signer(hs256(token_secret))
    |> verify
    |> case do
      %{claims: %{"type" => "driver", "id" => id}} ->
        VsaDriver.Core.get_driver!(id)

      _ ->
        nil
    end
  end

  def token_secret do
    Application.get_env(:vsa_driver, VsaDriverWeb.Endpoint)[:secret_key_base]
  end
end
