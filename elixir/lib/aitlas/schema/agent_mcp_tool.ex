defmodule Aitlas.Schema.AgentMcpTool do
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

    belongs_to(:agent, Aitlas.Schema.Agent, foreign_key: :agent_id, define_field: false)

    timestamps(inserted_at: :created_at)
  end

  def changeset(tool, attrs) do
    tool
    |> cast(attrs, [:agent_id, :name, :description, :input_schema, :credit_cost, :is_enabled])
    |> validate_required([:agent_id, :name])
  end
end