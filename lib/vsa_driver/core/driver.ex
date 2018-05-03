defmodule VsaDriver.Core.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  schema "drivers" do
    field(:badge_number, :string)
    field(:company, :string)
    field(:email, :string)
    field(:first_name, :string)
    field(:frequent, :boolean, default: false)
    field(:hazmat_authorized, :boolean, default: false)
    field(:last_name, :string)
    field(:license, :string)
    field(:password_confirmation_number, :string)
    field(:password_expires, :utc_datetime)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:confirmed, :boolean, default: false)
    field(:password_hash, :string)
    field(:phone_number, :string)
    has_one(:vehicle_details, VsaDriver.Core.VehicleDetail)
    has_one(:workorder_details, VsaDriver.Core.WorkorderDetail)

    timestamps()
  end

  @doc false
  def registration_changeset(%__MODULE__{} = driver, attrs) do
    driver
    |> cast(attrs, [
      :email,
      :license,
      :password,
      :password_confirmation,
      :password_confirmation_number,
      :first_name,
      :last_name,
      :phone_number,
      :company,
      :hazmat_authorized,
      :frequent,
      :badge_number,
      :password_expires
    ])
    |> validate_required([
      :email,
      :license,
      :password,
      :password_confirmation,
      :password_confirmation_number
    ])
    |> unique_constraint(:email)
    |> unique_constraint(:license)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> password_confirmation()
    |> downcase_email()
    |> put_pass_hash()
  end

  def update_password_changeset(%__MODULE__{} = driver, attrs \\ %{}) do
    driver
    |> cast(attrs, [:password_confirmation_number, :password, :password_confirmation])
    |> validate_required([:password_confirmation_number, :password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> password_confirmation()
    |> put_pass_hash()
  end

  def forgot_password_changeset(%__MODULE__{} = driver, attrs \\ %{}) do
    driver
    |> cast(attrs, [:password_confirmation_number, :confirmed])
  end

  def confirmation_changeset(%__MODULE__{} = driver, attrs \\ %{}) do
    driver
    |> cast(attrs, [:password_confirmation_number, :confirmed])
    |> do_confirmation()
  end

  def changeset(%__MODULE__{} = driver, attrs) do
    driver
    |> cast(attrs, [
      :email,
      :license,
      :first_name,
      :last_name,
      :phone_number,
      :company,
      :hazmat_authorized,
      :frequent,
      :badge_number,
      :password_confirmation_number,
      :password_expires
    ])
    |> validate_required([:email, :license])
    |> unique_constraint(:email)
    |> unique_constraint(:license)
    |> validate_format(:email, ~r/@/)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Argon2.hashpwsalt(pass))

      _ ->
        changeset
    end
  end

  defp downcase_email(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        changeset
        |> put_change(:email, String.downcase(email))

      _ ->
        changeset
    end
  end

  defp password_confirmation(%Ecto.Changeset{valid?: false} = changeset) do
    changeset
  end

  defp password_confirmation(%Ecto.Changeset{valid?: true} = changeset) do
    case changeset do
      %Ecto.Changeset{
        changes: %{password: password, password_confirmation: password}
      } ->
        changeset

      _ ->
        changeset
        |> add_error(:password_confirmation, "does not match password")
    end
  end

  defp do_confirmation(changeset) do
    changeset
    |> put_change(:password_confirmation_number, nil)
    |> put_change(:confirmed, true)
  end
end
