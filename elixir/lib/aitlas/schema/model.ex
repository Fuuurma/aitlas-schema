defmodule Aitlas.Schema.Model do
  @moduledoc """
  AI Model schema with pricing and capabilities.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "models" do
    field(:provider_id, :string)
    field(:name, :string)
    field(:display_name, :string)
    field(:context_window, :integer, default: 4096)
    field(:max_output_tokens, :integer, default: 4096)
    field(:input_cost_per_1k, :decimal, default: Decimal.new("0"))
    field(:output_cost_per_1k, :decimal, default: Decimal.new("0"))
    field(:supports_vision, :boolean, default: false)
    field(:supports_tools, :boolean, default: true)
    field(:supports_streaming, :boolean, default: true)
    field(:capabilities, {:array, :string}, default: [])
    field(:enabled, :boolean, default: true)

    belongs_to(:provider, Aitlas.Schema.Provider, foreign_key: :provider_id, define_field: false)

    timestamps(updated_at: false)
  end

  def changeset(model, attrs) do
    model
    |> cast(attrs, [:id, :provider_id, :name, :display_name, :context_window, 
                    :max_output_tokens, :input_cost_per_1k, :output_cost_per_1k,
                    :supports_vision, :supports_tools, :supports_streaming, 
                    :capabilities, :enabled])
    |> validate_required([:id, :provider_id, :name])
  end
end