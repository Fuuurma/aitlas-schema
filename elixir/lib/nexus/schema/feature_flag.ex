defmodule Nexus.Schema.FeatureFlag do
  @moduledoc """
  Feature flag definition.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "feature_flags" do
    field(:name, :string)
    field(:description, :string)
    field(:enabled, :boolean, default: false)
    field(:rollout_percentage, :integer, default: 0)
    field(:conditions, :map, default: %{})

    timestamps(inserted_at: :created_at)
  end

  def changeset(flag, attrs) do
    flag
    |> cast(attrs, [:id, :name, :description, :enabled, :rollout_percentage, :conditions])
    |> validate_required([:id, :name])
    |> unique_constraint(:name)
  end
end