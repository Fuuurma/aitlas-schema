defmodule Aitlas.Schema.CurationReview do
  @moduledoc """
  Admin curation workflow for agent reviews.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "curation_reviews" do
    field(:reviewer_id, :string)
    field(:status, :string, default: "pending")
    field(:tier, :string, default: "automated")
    field(:automated_checks, :map)
    field(:notes, :string)
    field(:rejection_reason, :string)
    field(:resolved_at, :utc_datetime_usec)

    belongs_to(:agent, Aitlas.Schema.Agent)
    belongs_to(:version, Aitlas.Schema.AgentVersion)

    timestamps(inserted_at: :created_at)
  end

  @valid_statuses ~w(pending approved rejected changes_requested)
  @valid_tiers ~w(automated human verified)

  def changeset(review, attrs) do
    review
    |> cast(attrs, [
      :reviewer_id,
      :status,
      :tier,
      :automated_checks,
      :notes,
      :rejection_reason,
      :resolved_at,
      :agent_id,
      :version_id
    ])
    |> validate_required([:status])
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_inclusion(:tier, @valid_tiers)
    |> foreign_key_constraint(:agent_id)
    |> foreign_key_constraint(:version_id)
  end
end
