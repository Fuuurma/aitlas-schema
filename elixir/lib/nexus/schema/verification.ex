defmodule Nexus.Schema.Verification do
  @moduledoc """
  Verification schema for email verification tokens.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "verifications" do
    field(:identifier, :string)
    field(:value, :string)
    field(:expires_at, :utc_datetime)

    timestamps(inserted_at: :created_at)
  end

  def changeset(verification, attrs) do
    verification
    |> cast(attrs, [:id, :identifier, :value, :expires_at])
    |> validate_required([:id, :identifier, :value, :expires_at])
  end
end