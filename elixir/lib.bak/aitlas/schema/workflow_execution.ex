defmodule Aitlas.Schema.WorkflowExecution do
  @moduledoc """
  Workflow execution instance.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "workflow_executions" do
    field(:workflow_id, :string)
    field(:user_id, :string)
    field(:status, :string, default: "pending")
    field(:input, :map)
    field(:output, :map)
    field(:error, :string)
    field(:current_step, :string)
    field(:context, :map, default: %{})
    field(:started_at, :utc_datetime)
    field(:completed_at, :utc_datetime)

    belongs_to(:workflow, Aitlas.Schema.Workflow, foreign_key: :workflow_id, define_field: false)

    timestamps(updated_at: false)
  end

  def changeset(execution, attrs) do
    execution
    |> cast(attrs, [:id, :workflow_id, :user_id, :status, :input, :output,
                    :error, :current_step, :context, :started_at, :completed_at])
    |> validate_required([:id, :workflow_id])
  end
end