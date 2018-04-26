defmodule VsaDriver.Core.VehicleDetail do
  use Ecto.Schema
  import Ecto.Changeset


  schema "vehicle_details" do
    field :seals, :boolean, default: false
    field :sleeper_cab, :boolean, default: false
    field :trailer_length, :integer
    field :turn_radius, :integer
    field :vehicle_type, :string
    field :driver_id, :id

    timestamps()
  end

  @doc false
  def changeset(vehicle_detail, attrs) do
    vehicle_detail
    |> cast(attrs, [:vehicle_type, :turn_radius, :trailer_length, :sleeper_cab, :seals])
    |> validate_required([:vehicle_type, :turn_radius, :trailer_length, :sleeper_cab, :seals])
  end
end
