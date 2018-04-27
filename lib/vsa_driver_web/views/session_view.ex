defmodule VsaDriverWeb.SessionView do
  use VsaDriverWeb, :view
  use JaSerializer.PhoenixView

  attributes [:token]
end
