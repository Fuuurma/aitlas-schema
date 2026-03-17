defmodule Aitlas.Schema.Role do
  @moduledoc """
  Agent roles with inference keywords.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "roles" do
    field(:slug, :string)
    field(:name, :string)
    field(:display_name, :string)
    field(:description, :string)
    field(:keywords, {:array, :string}, default: [])
    field(:sort_order, :integer, default: 0)
    field(:is_active, :boolean, default: true)

    timestamps()
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:slug, :name, :display_name, :description, :keywords, :sort_order, :is_active])
    |> validate_required([:slug, :name, :display_name])
    |> unique_constraint(:slug)
  end
end
