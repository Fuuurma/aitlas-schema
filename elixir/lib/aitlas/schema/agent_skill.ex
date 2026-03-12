defmodule Aitlas.Schema.AgentSkill do
  @moduledoc """
  Agent skill configuration.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agent_skills" do
    field(:agent_id, :binary_id)
    field(:name, :string)
    field(:description, :string)
    field(:instructions, :string)
    field(:triggers, {:array, :string}, default: [])
    field(:version, :string)

    belongs_to(:agent, Aitlas.Schema.Agent, foreign_key: :agent_id, define_field: false)

    timestamps()
  end

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:agent_id, :name, :description, :instructions, :triggers, :version])
    |> validate_required([:agent_id, :name])
  end
end