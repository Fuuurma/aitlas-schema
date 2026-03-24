defmodule Nexus.Schema.SkillExecution do
  @moduledoc """
  Skill execution log.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "skill_executions" do
    field(:skill_id, :string)
    field(:task_id, :binary_id)
    field(:input, :map)
    field(:output, :map)
    field(:error, :string)
    field(:duration_ms, :integer)
    field(:success, :boolean)

    belongs_to(:skill, Nexus.Schema.Skill, foreign_key: :skill_id, define_field: false)

    timestamps(updated_at: false, inserted_at: :created_at)
  end

  def changeset(execution, attrs) do
    execution
    |> cast(attrs, [:id, :skill_id, :task_id, :input, :output, :error, :duration_ms, :success])
    |> validate_required([:id, :skill_id, :input])
  end
end