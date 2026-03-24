defmodule Nexus.Schema.SystemPrompt do
  @moduledoc """
  System prompt template.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "system_prompts" do
    field(:name, :string)
    field(:description, :string)
    field(:content, :string)
    field(:variables, {:array, :map}, default: [])
    field(:category, :string)
    field(:tags, {:array, :string}, default: [])
    field(:version, :integer, default: 1)

    timestamps(inserted_at: :created_at)
  end

  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:id, :name, :description, :content, :variables, :category, :tags, :version])
    |> validate_required([:id, :name, :content])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:content, min: 1)
    |> validate_number(:version, greater_than: 0)
  end
end