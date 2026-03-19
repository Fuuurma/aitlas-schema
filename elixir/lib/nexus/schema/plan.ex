defmodule Nexus.Schema.Plan do
  @moduledoc """
  Subscription plan schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "plans" do
    field(:name, :string)
    field(:display_name, :string)
    field(:description, :string)
    field(:price_monthly, :decimal, default: Decimal.new("0"))
    field(:price_yearly, :decimal, default: Decimal.new("0"))
    field(:credits_included, :integer, default: 0)
    field(:credits_per_month, :integer, default: 0)
    field(:features, :map, default: %{})
    field(:limits, :map, default: %{})
    field(:stripe_product_id, :string)
    field(:stripe_price_monthly_id, :string)
    field(:stripe_price_yearly_id, :string)
    field(:is_active, :boolean, default: true)
    field(:is_default, :boolean, default: false)

    has_many(:subscriptions, Nexus.Schema.Subscription)

    timestamps(inserted_at: :created_at)
  end

  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:id, :name, :display_name, :description, :price_monthly, :price_yearly,
                    :credits_included, :credits_per_month, :features, :limits,
                    :stripe_product_id, :stripe_price_monthly_id, :stripe_price_yearly_id,
                    :is_active, :is_default])
    |> validate_required([:id, :name])
  end
end