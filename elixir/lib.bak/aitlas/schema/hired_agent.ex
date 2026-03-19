defmodule Aitlas.Schema.HiredAgent do
  @moduledoc """
  User's hired/installed agents with subscription tracking.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "hired_agents" do
    field(:user_id, :string)
    field(:status, :string, default: "active")
    field(:hired_at, :utc_datetime)
    field(:expires_at, :utc_datetime)
    field(:total_runs, :integer, default: 0)
    field(:last_run_at, :utc_datetime)

    belongs_to(:agent, Aitlas.Schema.Agent)

    timestamps(inserted_at: :created_at)
  end

  @valid_statuses ~w(active paused expired)

  def changeset(hired_agent, attrs) do
    hired_agent
    |> cast(attrs, [
      :user_id,
      :status,
      :hired_at,
      :expires_at,
      :total_runs,
      :last_run_at,
      :agent_id
    ])
    |> validate_required([:user_id, :agent_id])
    |> validate_inclusion(:status, @valid_statuses)
    |> foreign_key_constraint(:agent_id)
    |> unique_constraint([:user_id, :agent_id])
  end
end
