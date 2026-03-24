defmodule Nexus.Schema.Subscription do
  @moduledoc """
  User subscription schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "subscriptions" do
    field(:user_id, :string)
    field(:plan_id, :string)
    field(:status, :string, default: "active")
    field(:stripe_subscription_id, :string)
    field(:stripe_customer_id, :string)
    field(:current_period_start, :utc_datetime)
    field(:current_period_end, :utc_datetime)
    field(:cancel_at_period_end, :boolean, default: false)
    field(:cancelled_at, :utc_datetime)

    belongs_to(:user, Nexus.Schema.User, foreign_key: :user_id, define_field: false)
    belongs_to(:plan, Nexus.Schema.Plan, foreign_key: :plan_id, define_field: false)

    timestamps(inserted_at: :created_at)
  end

  @valid_statuses ~w(active cancelled past_due expired trialing)

  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:id, :user_id, :plan_id, :status, :stripe_subscription_id,
                    :stripe_customer_id, :current_period_start, :current_period_end,
                    :cancel_at_period_end, :cancelled_at])
    |> validate_required([:id, :user_id, :plan_id])
    |> validate_inclusion(:status, @valid_statuses)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:plan_id)
  end
end