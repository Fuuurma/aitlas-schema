defmodule Nexus.Schema.CreditRate do
  @moduledoc """
  Credit rate per model.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "credit_rates" do
    field(:model_id, :string)
    field(:input_cost_per_token, :decimal)
    field(:output_cost_per_token, :decimal)
    field(:effective_from, :utc_datetime)

    belongs_to(:model, Nexus.Schema.Model, foreign_key: :model_id, define_field: false)

    timestamps(updated_at: false, inserted_at: :created_at)
  end

  def changeset(rate, attrs) do
    rate
    |> cast(attrs, [:id, :model_id, :input_cost_per_token, :output_cost_per_token, :effective_from])
    |> validate_required([:id, :model_id, :input_cost_per_token, :output_cost_per_token])
  end
end