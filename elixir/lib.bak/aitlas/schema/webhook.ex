defmodule Aitlas.Schema.Webhook do
  @moduledoc """
  Webhook configuration schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "webhooks" do
    field(:user_id, :string)
    field(:name, :string)
    field(:url, :string)
    field(:secret, :string)
    field(:events, {:array, :string}, default: [])
    field(:enabled, :boolean, default: true)
    field(:last_triggered_at, :utc_datetime)

    belongs_to(:user, Aitlas.Schema.User, foreign_key: :user_id, define_field: false)
    has_many(:deliveries, Aitlas.Schema.WebhookDelivery)

    timestamps(updated_at: false)
  end

  def changeset(webhook, attrs) do
    webhook
    |> cast(attrs, [:id, :user_id, :name, :url, :secret, :events, :enabled, :last_triggered_at])
    |> validate_required([:id, :user_id, :name, :url])
  end
end