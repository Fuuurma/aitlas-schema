defmodule Nexus.Schema.Agent do
  @moduledoc """
  Agent schema for agent templates with store features.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "agents" do
    field(:name, :string)
    field(:slug, :string)
    field(:display_name, :string)
    field(:description, :string)
    field(:long_description, :string)
    field(:system_prompt, :string)
    field(:category, :string)
    field(:category_id, :binary_id)
    field(:role, :string, default: "assistant")
    field(:role_id, :binary_id)
    field(:tags, {:array, :string}, default: [])
    field(:current_version, :string, default: "1.0.0")
    field(:status, :string, default: "draft")
    field(:risk_level, :string, default: "unknown")
    field(:source, :string)
    field(:source_url, :string)
    field(:stars, :integer, default: 0)
    field(:forks, :integer, default: 0)
    field(:run_count, :integer, default: 0)
    field(:avg_rating, :decimal)
    field(:review_count, :integer, default: 0)
    field(:success_rate, :decimal)
    field(:image_url, :string)
    field(:cover_url, :string)
    field(:color, :string)
    field(:emoji, :string)
    field(:vibe, :string)
    field(:author, :string)
    field(:price, :integer, default: 0)
    field(:is_published, :boolean, default: false)
    field(:is_featured, :boolean, default: false)
    field(:is_verified, :boolean, default: false)
    field(:featured_order, :integer)
    field(:version, :string)
    field(:creator_id, :binary_id)

    belongs_to(:creator, Nexus.Schema.Creator, define_field: false)

    has_many(:skills, Nexus.Schema.AgentSkill)
    has_many(:mcp_tools, Nexus.Schema.AgentMcpTool)
    has_many(:actions, Nexus.Schema.AgentAction)
    has_many(:versions, Nexus.Schema.AgentVersion)
    has_many(:reviews, Nexus.Schema.AgentReview)
    has_many(:subscriptions, Nexus.Schema.AgentSubscription)
    has_many(:run_events, Nexus.Schema.AgentRunEvent)

    timestamps(inserted_at: :created_at)
  end

  @valid_risk_levels ~w(safe unknown critical)
  @valid_statuses ~w(draft review published unlisted deprecated removed)
  @valid_roles ~w(researcher coder analyst writer operator trader guardian assistant advisor)

  def changeset(agent, attrs) do
    agent
    |> cast(attrs, [
      :name,
      :slug,
      :display_name,
      :description,
      :long_description,
      :system_prompt,
      :category,
      :category_id,
      :role,
      :role_id,
      :tags,
      :current_version,
      :status,
      :risk_level,
      :source,
      :source_url,
      :stars,
      :forks,
      :run_count,
      :avg_rating,
      :review_count,
      :success_rate,
      :image_url,
      :cover_url,
      :color,
      :emoji,
      :vibe,
      :author,
      :price,
      :is_published,
      :is_featured,
      :is_verified,
      :featured_order,
      :version,
      :creator_id
    ])
    |> validate_required([:name, :category])
    |> validate_inclusion(:risk_level, @valid_risk_levels)
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_inclusion(:role, @valid_roles)
    |> unique_constraint(:slug)
  end
end
