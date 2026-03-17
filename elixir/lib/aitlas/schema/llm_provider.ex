defmodule Aitlas.Schema.LlmProvider do
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

    timestamps()
  end

  def changeset(provider, attrs) do
    provider
    |> cast(attrs, [:slug, :name, :display_name, :website_url, :is_active, :sort_order])
    |> validate_required([:slug, :name, :display_name])
    |> unique_constraint(:slug)
  end
end
