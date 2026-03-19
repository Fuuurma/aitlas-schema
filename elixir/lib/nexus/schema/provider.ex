defmodule Nexus.Schema.Provider do
  @moduledoc """
  AI Provider schema (OpenAI, Anthropic, Gemini, etc).
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "providers" do
    field(:name, :string)
    field(:display_name, :string)
    field(:description, :string)
    field(:base_url, :string)
    field(:api_key_env, :string)
    field(:rate_limit_rpm, :integer, default: 60)
    field(:rate_limit_tpm, :integer, default: 90000)
    field(:enabled, :boolean, default: true)
    field(:config, :map, default: %{})

    has_many(:models, Nexus.Schema.Model)

    timestamps(inserted_at: :created_at)
  end

  def changeset(provider, attrs) do
    provider
    |> cast(attrs, [:id, :name, :display_name, :description, :base_url, :api_key_env, 
                    :rate_limit_rpm, :rate_limit_tpm, :enabled, :config])
    |> validate_required([:id, :name])
  end
end