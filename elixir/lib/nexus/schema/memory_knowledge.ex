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

  @valid_confidence ~w(low medium high)

  def changeset(knowledge, attrs) do
    knowledge
    |> cast(attrs, [:id, :user_id, :key, :value, :category, :confidence, :source])
    |> validate_required([:id, :user_id, :key, :value])
    |> validate_inclusion(:confidence, @valid_confidence)
    |> validate_length(:key, min: 1, max: 255)
    |> unique_constraint([:user_id, :key], name: :memory_knowledge_user_id_key_index)
  end
end