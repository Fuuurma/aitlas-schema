defmodule Nexus.Schema.McpTool do
  @moduledoc """
  MCP tool definition.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "mcp_tools" do
    field(:server_id, :string)
    field(:name, :string)
    field(:description, :string)
    field(:input_schema, :map)
    field(:output_schema, :map)
    field(:annotations, :map, default: %{})
    field(:enabled, :boolean, default: true)

    belongs_to(:server, Nexus.Schema.McpServer, foreign_key: :server_id, define_field: false)

    timestamps(updated_at: false, inserted_at: :created_at)
  end

  def changeset(tool, attrs) do
    tool
    |> cast(attrs, [:id, :server_id, :name, :description, :input_schema, :output_schema, :annotations, :enabled])
    |> validate_required([:id, :server_id, :name, :input_schema])
    |> validate_length(:name, min: 1, max: 255)
    |> unique_constraint([:server_id, :name], name: :mcp_tools_server_id_name_index)
  end
end