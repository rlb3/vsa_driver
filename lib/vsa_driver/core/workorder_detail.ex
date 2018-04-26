defmodule VsaDriver.Core.WorkorderDetail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workorder_details" do
    field(:cargo_content, :string)
    field(:poc_extention, :string)
    field(:poc_name, :string)
    field(:poc_phone, :string)
    belongs_to(:driver, VsaDriver.Core.Driver)

    timestamps()
  end

  @doc false
  def changeset(workorder_detail, attrs) do
    workorder_detail
    |> cast(attrs, [:poc_name, :poc_phone, :poc_extention, :cargo_content])
    |> validate_required([:poc_name, :poc_phone, :poc_extention, :cargo_content])
  end
end
