defmodule VsaDriverWeb.WorkorderDetailSerializer do
  use JaSerializer

  # location("/drivers/:driver_id/workorder_details")
  attributes([:cargo_content, :poc_extention, :poc_name, :poc_phone])
end
