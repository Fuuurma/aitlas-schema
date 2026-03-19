defmodule Nexus.Schema.MemoryKnowledge do
  @moduledoc """
  Knowledge base entry.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "memory_knowledge" do
    field(:user_id, :string)
    field(:key, :string)
    field(:value, :string)
    field(:category, :string)
    field(:confidence, :string, default: "medium")
    field(:source, :string)

    belongs_to(:user, Nexus.Schema.User, foreign_key: :user_id, define_field: false)

    timestamps(inserted_at: :created_at)
  end

  def changeset(knowledge, attrs) do
    knowledge
    |> cast(attrs, [:id, :user_id, :key, :value, :category, :confidence, :source])
    |> validate_required([:id, :user_id, :key, :value])
  end
end