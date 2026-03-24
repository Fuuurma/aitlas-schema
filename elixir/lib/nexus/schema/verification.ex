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
    |> validate_future_datetime(:expires_at)
    |> unique_constraint([:identifier, :value], name: :verifications_identifier_value_index)
  end

  defp validate_future_datetime(changeset, field) do
    validate_change(changeset, field, fn ^field, datetime ->
      case DateTime.compare(datetime, DateTime.utc_now()) do
        :lt -> [{field, "must be in the future"}]
        _ -> []
      end
    end)
  end
end