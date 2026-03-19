defmodule Nexus.Schema.TaskStep do
  @moduledoc """
  Task step for execution tracking.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "task_steps" do
    field(:task_id, :binary_id)
    field(:step_number, :integer)
    field(:action, :string)
    field(:input, :map)
    field(:output, :map)
    field(:metadata, :map, default: %{})

    belongs_to(:task, Nexus.Schema.Task, foreign_key: :task_id, define_field: false)

    timestamps(updated_at: false)
  end

  def changeset(step, attrs) do
    step
    |> cast(attrs, [:task_id, :step_number, :action, :input, :output, :metadata])
    |> validate_required([:task_id, :step_number, :action])
  end
end