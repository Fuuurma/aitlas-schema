defmodule Nexus.Schema.Category do
  @moduledoc """
  Agent categories for organization and discovery.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "categories" do
    field(:slug, :string)
    field(:name, :string)
    field(:display_name, :string)
    field(:description, :string)
    field(:sort_order, :integer, default: 0)
    field(:is_active, :boolean, default: true)

    timestamps(inserted_at: :created_at)
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:slug, :name, :display_name, :description, :sort_order, :is_active])
    |> validate_required([:slug, :name, :display_name])
    |> unique_constraint(:slug)
  end
end
