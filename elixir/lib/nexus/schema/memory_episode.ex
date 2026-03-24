defmodule Nexus.Schema.MemoryEpisode do
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

    belongs_to(:user, Nexus.Schema.User, foreign_key: :user_id, define_field: false)

    timestamps(updated_at: false, inserted_at: :created_at)
  end

  @valid_importance ~w(low medium high)

  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [:id, :user_id, :task_id, :content, :metadata, :importance])
    |> validate_required([:id, :user_id, :content])
    |> validate_inclusion(:importance, @valid_importance)
    |> validate_length(:content, min: 1, max: 100_000)
  end
end