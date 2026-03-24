defmodule Nexus.Schema.ToolCall do
  @moduledoc """
  Tool call execution log.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tool_calls" do
    field(:task_id, :binary_id)
    field(:step_id, :binary_id)
    field(:tool_name, :string)
    field(:arguments, :map)
    field(:result, :map)
    field(:error, :string)
    field(:child_task_id, :binary_id)

    belongs_to(:task, Nexus.Schema.Task, foreign_key: :task_id, define_field: false)

    timestamps(updated_at: false, inserted_at: :created_at)
  end

  def changeset(tool_call, attrs) do
    tool_call
    |> cast(attrs, [:task_id, :step_id, :tool_name, :arguments, :result, :error, :child_task_id])
    |> validate_required([:task_id, :tool_name, :arguments])
  end
end