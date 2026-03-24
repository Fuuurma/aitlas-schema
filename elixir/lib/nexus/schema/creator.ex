defmodule Nexus.Schema.Creator do
  @moduledoc """
  Agent creator profile with earnings and verification.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "creators" do
    field(:user_id, :string)
    field(:username, :string)
    field(:display_name, :string)
    field(:bio, :string)
    field(:avatar_url, :string)
    field(:website_url, :string)
    field(:tier, :string, default: "community")
    field(:is_verified, :boolean, default: false)
    field(:stripe_account_id, :string)
    field(:total_earnings, :decimal, default: Decimal.new("0"))

    belongs_to(:user, Nexus.Schema.User, foreign_key: :user_id, define_field: false)
    has_many(:agents, Nexus.Schema.Agent)
    has_many(:earnings, Nexus.Schema.CreatorEarning)
    has_many(:payouts, Nexus.Schema.CreatorPayout)

    timestamps(inserted_at: :created_at)
  end

  @valid_tiers ~w(community verified partner)

  def changeset(creator, attrs) do
    creator
    |> cast(attrs, [
      :user_id,
      :username,
      :display_name,
      :bio,
      :avatar_url,
      :website_url,
      :tier,
      :is_verified,
      :stripe_account_id,
      :total_earnings
    ])
    |> validate_required([:user_id, :username, :display_name])
    |> validate_inclusion(:tier, @valid_tiers)
    |> validate_length(:username, min: 1, max: 100)
    |> validate_length(:display_name, min: 1, max: 255)
    |> unique_constraint(:username)
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
