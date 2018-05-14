defmodule VsaDriverWeb.Auth do
  import Plug.Conn, only: [get_req_header: 2]
  import Joken

  alias VsaDriver.Core.Driver

  @moduledoc false

  def init(opt) do
    opt
  end

  def call(conn, _opt) do
    conn
    |> ensure_token
  end

  defp ensure_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        check_allowed_user(conn, token)

      [] ->
        conn
    end
  end

  def check_allowed_user(conn, token) do
    case check_driver(token) do
      %Driver{} = driver ->
        %{conn | assigns: Map.put(conn.assigns, :current_driver, driver)}

      _ ->
        case check_role(token) do
          true ->
            %{conn | assigns: Map.put(conn.assigns, :is_role, true)}

          _ ->
            conn
        end
    end
  end

  defp check_role(token) do
    token
    |> token
    |> with_signer(hs256(token_secret()))
    |> verify
    |> case do
      %{claims: %{"type" => "role"}} ->
        true

      _claims ->
        nil
    end
  end

  defp check_driver(token) do
    token
    |> token
    |> with_signer(hs256(token_secret()))
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
