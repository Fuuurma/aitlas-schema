defmodule Nexus.Schema.CreditPackage do
  @moduledoc """
  Credit packages for purchase.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "credit_packages" do
    field(:credits, :integer)
    field(:price_cents, :integer)
    field(:display_name, :string)
    field(:is_popular, :boolean, default: false)
    field(:is_active, :boolean, default: true)
    field(:sort_order, :integer, default: 0)

    timestamps(inserted_at: :created_at)
  end

  def changeset(package, attrs) do
    package
    |> cast(attrs, [:credits, :price_cents, :display_name, :is_popular, :is_active, :sort_order])
    |> validate_required([:credits, :price_cents, :display_name])
    |> validate_number(:credits, greater_than: 0)
    |> validate_number(:price_cents, greater_than: 0)
  end
end
