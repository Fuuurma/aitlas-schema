defmodule Nexus.Schema.AgentMcpTool do
  @moduledoc """
  Agent MCP tool configuration.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agent_mcp_tools" do
    field(:agent_id, :binary_id)
    field(:name, :string)
    field(:description, :string)
    field(:input_schema, :map)
    field(:credit_cost, :integer, default: 0)
    field(:is_enabled, :boolean, default: true)

    belongs_to(:agent, Nexus.Schema.Agent, foreign_key: :agent_id, define_field: false)

    timestamps(inserted_at: :created_at)
  end

  def changeset(tool, attrs) do
    tool
    |> cast(attrs, [:agent_id, :name, :description, :input_schema, :credit_cost, :is_enabled])
    |> validate_required([:agent_id, :name])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_number(:credit_cost, greater_than_or_equal_to: 0)
    |> unique_constraint([:agent_id, :name], name: :agent_mcp_tools_agent_id_name_index)
  end
end