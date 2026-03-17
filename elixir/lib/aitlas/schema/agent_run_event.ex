defmodule Aitlas.Schema.AgentRunEvent do
  @moduledoc """
  Agent run events from Nexus for analytics.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agent_run_events" do
    field(:task_id, :string)
    field(:user_id, :string)
    field(:version, :string)
    field(:status, :string)
    field(:credits_used, :integer)
    field(:duration_ms, :integer)

    belongs_to(:agent, Aitlas.Schema.Agent)

    timestamps(updated_at: false)
  end

  @valid_statuses ~w(completed failed stuck timeout)

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:task_id, :user_id, :version, :status, :credits_used, :duration_ms, :agent_id])
    |> validate_required([:task_id, :user_id, :version, :status])
    |> validate_inclusion(:status, @valid_statuses)
    |> foreign_key_constraint(:agent_id)
  end
end
