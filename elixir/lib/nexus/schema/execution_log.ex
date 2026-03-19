defmodule Nexus.Schema.ExecutionLog do
  @moduledoc """
  Execution log for debugging.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "execution_logs" do
    field(:task_id, :binary_id)
    field(:agent_id, :string)
    field(:level, :string)
    field(:message, :string)
    field(:metadata, :map, default: %{})

    timestamps(updated_at: false)
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [:id, :task_id, :agent_id, :level, :message, :metadata])
    |> validate_required([:id, :level, :message])
  end
end