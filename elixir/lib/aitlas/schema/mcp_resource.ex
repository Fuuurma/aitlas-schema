defmodule Aitlas.Schema.McpResource do
  @moduledoc """
  MCP resource definition.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "mcp_resources" do
    field(:server_id, :string)
    field(:uri, :string)
    field(:name, :string)
    field(:description, :string)
    field(:mime_type, :string)
    field(:size_bytes, :integer)

    belongs_to(:server, Aitlas.Schema.McpServer, foreign_key: :server_id, define_field: false)

    timestamps(updated_at: false)
  end

  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:id, :server_id, :uri, :name, :description, :mime_type, :size_bytes])
    |> validate_required([:id, :server_id, :uri, :name])
  end
end