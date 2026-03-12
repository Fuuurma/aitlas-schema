defmodule Aitlas.Schema.AgentAction do
  @moduledoc """
  Agent action definition.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agent_actions" do
    field(:agent_id, :binary_id)
    field(:name, :string)
    field(:description, :string)
    field(:mcp_endpoint, :string)
    field(:action_schema, :map)
    field(:credit_cost, :integer, default: 0)
    field(:version, :string)

    belongs_to(:agent, Aitlas.Schema.Agent, foreign_key: :agent_id, define_field: false)

    timestamps()
  end

  def changeset(action, attrs) do
    action
    |> cast(attrs, [:agent_id, :name, :description, :mcp_endpoint, :action_schema, :credit_cost, :version])
    |> validate_required([:agent_id, :name])
  end
end