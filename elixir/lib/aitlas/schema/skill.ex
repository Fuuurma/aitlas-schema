defmodule Aitlas.Schema.Skill do
  @moduledoc """
  Skill definition schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "skills" do
    field(:name, :string)
    field(:display_name, :string)
    field(:description, :string)
    field(:category, :string)
    field(:tags, {:array, :string}, default: [])
    field(:required_tools, {:array, :string}, default: [])
    field(:optional_tools, {:array, :string}, default: [])
    field(:config_schema, :map, default: %{})
    field(:default_config, :map, default: %{})
    field(:version, :string, default: "1.0.0")
    field(:enabled, :boolean, default: true)

    timestamps()
  end

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:id, :name, :display_name, :description, :category, :tags,
                    :required_tools, :optional_tools, :config_schema, :default_config,
                    :version, :enabled])
    |> validate_required([:id, :name])
    |> unique_constraint(:name)
  end
end