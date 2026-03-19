defmodule Aitlas.Schema.AgentReview do
  @moduledoc """
  User reviews for agents.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agent_reviews" do
    field(:user_id, :string)
    field(:rating, :integer)
    field(:body, :string)
    field(:run_id, :string)
    field(:is_verified_run, :boolean, default: false)
    field(:helpful_count, :integer, default: 0)

    belongs_to(:agent, Aitlas.Schema.Agent)

    timestamps(inserted_at: :created_at)
  end

  def changeset(review, attrs) do
    review
    |> cast(attrs, [
      :user_id,
      :rating,
      :body,
      :run_id,
      :is_verified_run,
      :helpful_count,
      :agent_id
    ])
    |> validate_required([:user_id, :rating])
    |> validate_inclusion(:rating, 1..5)
    |> foreign_key_constraint(:agent_id)
    |> unique_constraint([:agent_id, :user_id])
  end
end
