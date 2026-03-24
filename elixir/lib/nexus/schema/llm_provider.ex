defmodule Nexus.Schema.LlmProvider do
  @moduledoc """
  LLM providers for API key management.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "llm_providers" do
    field(:slug, :string)
    field(:name, :string)
    field(:display_name, :string)
    field(:website_url, :string)
    field(:is_active, :boolean, default: true)
    field(:sort_order, :integer, default: 0)

    timestamps(inserted_at: :created_at)
  end

  @url_format ~r/^https?:\/\/.+/

  def changeset(provider, attrs) do
    provider
    |> cast(attrs, [:slug, :name, :display_name, :website_url, :is_active, :sort_order])
    |> validate_required([:slug, :name, :display_name])
    |> validate_format(:website_url, @url_format, allow_nil: true, message: "must be a valid HTTP/HTTPS URL")
    |> unique_constraint(:slug)
  end
end
