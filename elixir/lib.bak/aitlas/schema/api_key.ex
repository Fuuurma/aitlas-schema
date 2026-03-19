defmodule Aitlas.Schema.ApiKey do
  @moduledoc """
  API Key schema for BYOK (Bring Your Own Key).
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "api_keys" do
    field(:user_id, :string)
    field(:provider, :string)
    field(:encrypted_key, :string)
    field(:iv, :string)
    field(:hint, :string)

    belongs_to(:user, Aitlas.Schema.User, foreign_key: :user_id, define_field: false)

    timestamps(inserted_at: :created_at)
  end

  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:user_id, :provider, :encrypted_key, :iv, :hint])
    |> validate_required([:user_id, :provider, :encrypted_key, :iv])
  end
end
