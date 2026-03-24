defmodule Nexus.Schema.AgentSkill do
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

    belongs_to(:agent, Nexus.Schema.Agent, foreign_key: :agent_id, define_field: false)

    timestamps(inserted_at: :created_at)
  end

  @valid_version_format ~r/^\d+\.\d+\.\d+(-[a-zA-Z0-9]+)?$/

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:agent_id, :name, :description, :instructions, :triggers, :version])
    |> validate_required([:agent_id, :name])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_format(:version, @valid_version_format, allow_nil: true)
    |> unique_constraint([:agent_id, :name], name: :agent_skills_agent_id_name_index)
  end
end