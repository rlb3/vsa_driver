defmodule VsaDriverWeb.Authorization do
  use VsaDriverWeb, :controller

  def init(opt) do
    opt
  end

  def call(conn, _opt) do
    current_driver = conn.assigns[:current_driver]
    is_role = conn.assigns[:is_role]

    cond do
      current_driver || is_role ->
        conn

      true ->
        conn
        |> put_status(401)
        |> json(%{error: "unauthenticated"})
        |> halt
    end
  end
end
