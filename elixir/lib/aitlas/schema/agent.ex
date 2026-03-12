defmodule Aitlas.Schema.Agent do
  @moduledoc """
  Agent schema for agent templates.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agents" do
    field(:name, :string)
    field(:description, :string)
    field(:system_prompt, :string)
    field(:category, :string)
    field(:risk_level, :string, default: "unknown")
    field(:source, :string)
    field(:source_url, :string)
    field(:stars, :integer, default: 0)
    field(:forks, :integer, default: 0)
    field(:image_url, :string)
    field(:price, :integer, default: 0)
    field(:is_published, :boolean, default: false)
    field(:version, :string)
    field(:color, :string)
    field(:emoji, :string)
    field(:vibe, :string)
    field(:author, :string)

    has_many(:skills, Aitlas.Schema.AgentSkill)
    has_many(:mcp_tools, Aitlas.Schema.AgentMcpTool)
    has_many(:actions, Aitlas.Schema.AgentAction)

    timestamps()
  end

  def changeset(agent, attrs) do
    agent
    |> cast(attrs, [:name, :description, :system_prompt, :category, :risk_level,
                    :source, :source_url, :stars, :forks, :image_url, :price,
                    :is_published, :version, :color, :emoji, :vibe, :author])
    |> validate_required([:name, :category])
  end
end