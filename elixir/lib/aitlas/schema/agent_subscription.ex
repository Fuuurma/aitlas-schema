defmodule Aitlas.Schema.AgentSubscription do
  @moduledoc """
  Paid agent subscriptions via Stripe.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agent_subscriptions" do
    field(:user_id, :string)
    field(:stripe_sub_id, :string)
    field(:status, :string, default: "active")
    field(:current_period_start, :utc_datetime_usec)
    field(:current_period_end, :utc_datetime_usec)
    field(:price_cents, :integer)
    field(:cancelled_at, :utc_datetime_usec)

    belongs_to(:agent, Aitlas.Schema.Agent)

    timestamps(inserted_at: :created_at)
  end

  @valid_statuses ~w(active cancelled past_due)

  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [
      :user_id,
      :stripe_sub_id,
      :status,
      :current_period_start,
      :current_period_end,
      :price_cents,
      :cancelled_at,
      :agent_id
    ])
    |> validate_required([:user_id, :price_cents])
    |> validate_inclusion(:status, @valid_statuses)
    |> foreign_key_constraint(:agent_id)
    |> unique_constraint(:stripe_sub_id)
  end
end
