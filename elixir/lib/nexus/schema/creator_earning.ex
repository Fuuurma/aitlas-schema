defmodule Nexus.Schema.CreatorEarning do
  @moduledoc """
  Creator earnings from agent subscriptions.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "creator_earnings" do
    field(:source, :string)
    field(:gross_amount, :decimal)
    field(:platform_fee, :decimal)
    field(:net_amount, :decimal)
    field(:stripe_event_id, :string)

    belongs_to(:creator, Nexus.Schema.Creator)
    belongs_to(:agent, Nexus.Schema.Agent)
    belongs_to(:payout, Nexus.Schema.CreatorPayout)

    timestamps(updated_at: false)
  end

  @valid_sources ~w(subscription payout)

  def changeset(earning, attrs) do
    earning
    |> cast(attrs, [
      :source,
      :gross_amount,
      :platform_fee,
      :net_amount,
      :stripe_event_id,
      :creator_id,
      :agent_id,
      :payout_id
    ])
    |> validate_required([:source, :gross_amount, :platform_fee, :net_amount])
    |> validate_inclusion(:source, @valid_sources)
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:agent_id)
    |> foreign_key_constraint(:payout_id)
  end
end
