defmodule Aitlas.Schema.UserFeatureFlag do
  @moduledoc """
  User-specific feature flag override.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "user_feature_flags" do
    field(:user_id, :string, primary_key: true)
    field(:flag_id, :string, primary_key: true)
    field(:enabled, :boolean)

    belongs_to(:user, Aitlas.Schema.User, foreign_key: :user_id, define_field: false)
    belongs_to(:flag, Aitlas.Schema.FeatureFlag, foreign_key: :flag_id, define_field: false)

    timestamps(updated_at: false)
  end

  def changeset(user_flag, attrs) do
    user_flag
    |> cast(attrs, [:user_id, :flag_id, :enabled])
    |> validate_required([:user_id, :flag_id, :enabled])
  end
end