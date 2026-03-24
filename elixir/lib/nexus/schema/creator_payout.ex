defmodule Nexus.Schema.CreatorPayout do
  @moduledoc """
  Creator payout records.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "creator_payouts" do
    field(:amount, :decimal)
    field(:stripe_payout_id, :string)
    field(:status, :string, default: "pending")
    field(:period_start, :date)
    field(:period_end, :date)
    field(:paid_at, :utc_datetime_usec)

    belongs_to(:creator, Nexus.Schema.Creator)
    has_many(:earnings, Nexus.Schema.CreatorEarning, foreign_key: :payout_id)

    timestamps(updated_at: false, inserted_at: :created_at)
  end

  @valid_statuses ~w(pending paid failed)

  def changeset(payout, attrs) do
    payout
    |> cast(attrs, [
      :amount,
      :stripe_payout_id,
      :status,
      :period_start,
      :period_end,
      :paid_at,
      :creator_id
    ])
    |> validate_required([:amount, :period_start, :period_end])
    |> validate_inclusion(:status, @valid_statuses)
    |> foreign_key_constraint(:creator_id)
  end
end
