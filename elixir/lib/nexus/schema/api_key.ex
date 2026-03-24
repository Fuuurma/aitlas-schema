defmodule Nexus.Schema.ApiKey do
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

    belongs_to(:user, Nexus.Schema.User, foreign_key: :user_id, define_field: false)

    timestamps(inserted_at: :created_at)
  end

  @valid_providers ~w(openai anthropic google cohere mistral openrouter custom)

  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:user_id, :provider, :encrypted_key, :iv, :hint])
    |> validate_required([:user_id, :provider, :encrypted_key, :iv])
    |> validate_inclusion(:provider, @valid_providers)
    |> unique_constraint([:user_id, :provider], name: :api_keys_user_id_provider_index)
  end
end
