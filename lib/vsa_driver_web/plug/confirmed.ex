defmodule VsaDriverWeb.Confirmed do
  use VsaDriverWeb, :controller

  @moduledoc false

  def init(opt) do
    opt
  end

  def call(%{assigns: %{current_driver: %{confirmed: true}}} = conn, _opt) do
    conn
  end

  def call(%{assigns: %{is_role: true}} = conn, _opt) do
    conn
  end

  def call(conn, _opt) do
    conn
    |> put_status(401)
    |> render(VsaDriverWeb.ErrorView, :"401.json-api")
    |> halt
  end
end
