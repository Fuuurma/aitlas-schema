defmodule Nexus.Schema.Task do
  @moduledoc """
  Task schema for agent execution.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tasks" do
    field(:user_id, :string)
    field(:agent_slug, :string)
    field(:agent_spec, :map)
    field(:goal, :string)
    field(:context, :string)
    field(:provider, :string)
    field(:model, :string)
    field(:seed, :integer)
    field(:credit_budget, :integer)
    field(:max_iterations, :integer, default: 20)
    field(:max_tool_calls, :integer, default: 50)
    field(:max_tokens, :integer, default: 200000)
    field(:max_runtime_ms, :integer, default: 1800000)
    field(:status, :string, default: "pending")
    field(:iteration, :integer, default: 0)
    field(:tool_calls_made, :integer, default: 0)
    field(:tokens_used, :integer, default: 0)
    field(:credits_used, :integer, default: 0)
    field(:credits_reserved, :integer, default: 0)
    field(:result, :string)
    field(:error, :string)
    field(:started_at, :utc_datetime)
    field(:completed_at, :utc_datetime)
    field(:execution_hash, :string)
    field(:parent_task_id, :binary_id)
    field(:root_task_id, :binary_id)
    field(:graph_depth, :integer, default: 0)
    field(:retry_count, :integer, default: 0)
    field(:worker_id, :string)
    field(:heartbeat_at, :utc_datetime)
    field(:replay_of_task_id, :binary_id)
    field(:fork_from_step, :integer)

    belongs_to(:user, Nexus.Schema.User, foreign_key: :user_id, define_field: false)
    has_many(:steps, Nexus.Schema.TaskStep)
    has_many(:tool_calls, Nexus.Schema.ToolCall)

    timestamps(inserted_at: :created_at)
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :user_id, :agent_slug, :agent_spec, :goal, :context, :provider, :model,
      :seed, :credit_budget, :max_iterations, :max_tool_calls, :max_tokens,
      :max_runtime_ms, :status, :iteration, :tool_calls_made, :tokens_used,
      :credits_used, :credits_reserved, :result, :error, :started_at,
      :completed_at, :execution_hash, :parent_task_id, :root_task_id,
      :graph_depth, :retry_count, :worker_id, :heartbeat_at,
      :replay_of_task_id, :fork_from_step
    ])
    |> validate_required([:user_id, :agent_slug, :goal, :provider])
  end
end