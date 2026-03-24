defmodule Nexus.Schema.PromptTemplate do
  @moduledoc """
  Reusable prompt template.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "prompt_templates" do
    field(:name, :string)
    field(:description, :string)
    field(:template, :string)
    field(:variables, {:array, :map}, default: [])
    field(:category, :string)
    field(:tags, {:array, :string}, default: [])
    field(:version, :integer, default: 1)

    timestamps(inserted_at: :created_at)
  end

  def changeset(template, attrs) do
    template
    |> cast(attrs, [:id, :name, :description, :template, :variables, :category, :tags, :version])
    |> validate_required([:id, :name, :template])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:template, min: 1)
    |> validate_number(:version, greater_than: 0)
    |> unique_constraint(:name)
  end
end