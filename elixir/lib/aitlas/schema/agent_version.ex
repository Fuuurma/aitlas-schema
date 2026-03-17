defmodule Aitlas.Schema.AgentVersion do
  @moduledoc """
  Agent version history.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agent_versions" do
    field(:version, :string)
    field(:spec, :map)
    field(:changelog, :string)
    field(:is_published, :boolean, default: false)
    field(:published_at, :utc_datetime_usec)

    belongs_to(:agent, Aitlas.Schema.Agent)

    timestamps()
  end

  def changeset(version, attrs) do
    version
    |> cast(attrs, [:version, :spec, :changelog, :is_published, :published_at, :agent_id])
    |> validate_required([:version, :spec])
    |> foreign_key_constraint(:agent_id)
    |> unique_constraint([:agent_id, :version])
  end
end
