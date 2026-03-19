defmodule Nexus.Schema.McpServer do
  @moduledoc """
  MCP server configuration.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "mcp_servers" do
    field(:name, :string)
    field(:display_name, :string)
    field(:description, :string)
    field(:transport, :string)
    field(:command, :string)
    field(:args, {:array, :string}, default: [])
    field(:env, :map, default: %{})
    field(:url, :string)
    field(:enabled, :boolean, default: true)
    field(:auto_start, :boolean, default: false)

    has_many(:tools, Nexus.Schema.McpTool, foreign_key: :server_id)
    has_many(:resources, Nexus.Schema.McpResource, foreign_key: :server_id)

    timestamps(updated_at: false)
  end

  def changeset(server, attrs) do
    server
    |> cast(attrs, [:id, :name, :display_name, :description, :transport, :command,
                    :args, :env, :url, :enabled, :auto_start])
    |> validate_required([:id, :name, :transport])
    |> unique_constraint(:name)
  end
end