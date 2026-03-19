defmodule Nexus.Schema.MemoryEmbedding do
  @moduledoc """
  Vector embedding for memory.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "memory_embeddings" do
    field(:memory_type, :string)
    field(:memory_id, :string)
    field(:content, :string)
    field(:embedding, :string)
    field(:metadata, :map, default: %{})

    timestamps(updated_at: false)
  end

  def changeset(embedding, attrs) do
    embedding
    |> cast(attrs, [:id, :memory_type, :memory_id, :content, :embedding, :metadata])
    |> validate_required([:id, :memory_type, :memory_id, :content])
  end
end