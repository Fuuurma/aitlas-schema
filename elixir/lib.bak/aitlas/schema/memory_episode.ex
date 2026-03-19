defmodule Aitlas.Schema.MemoryEpisode do
  @moduledoc """
  Episodic memory entry.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "memory_episodes" do
    field(:user_id, :string)
    field(:task_id, :string)
    field(:content, :string)
    field(:metadata, :map, default: %{})
    field(:importance, :string, default: "medium")

    belongs_to(:user, Aitlas.Schema.User, foreign_key: :user_id, define_field: false)

    timestamps(updated_at: false)
  end

  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [:id, :user_id, :task_id, :content, :metadata, :importance])
    |> validate_required([:id, :user_id, :content])
  end
end