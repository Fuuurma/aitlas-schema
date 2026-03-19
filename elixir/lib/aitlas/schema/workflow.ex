defmodule Aitlas.Schema.Workflow do
  @moduledoc """
  Workflow definition.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "workflows" do
    field(:name, :string)
    field(:description, :string)
    field(:definition, :map)
    field(:triggers, {:array, :map}, default: [])
    field(:input_schema, :map, default: %{})
    field(:output_schema, :map, default: %{})
    field(:enabled, :boolean, default: true)

    has_many(:executions, Aitlas.Schema.WorkflowExecution)

    timestamps(inserted_at: :created_at)
  end

  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [:id, :name, :description, :definition, :triggers,
                    :input_schema, :output_schema, :enabled])
    |> validate_required([:id, :name, :definition])
  end
end