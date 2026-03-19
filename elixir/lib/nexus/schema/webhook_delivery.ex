defmodule Nexus.Schema.WebhookDelivery do
  @moduledoc """
  Webhook delivery log.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "webhook_deliveries" do
    field(:webhook_id, :string)
    field(:event_type, :string)
    field(:payload, :map)
    field(:response_status, :integer)
    field(:response_body, :string)
    field(:attempts, :integer, default: 0)
    field(:delivered_at, :utc_datetime)

    belongs_to(:webhook, Nexus.Schema.Webhook, foreign_key: :webhook_id, define_field: false)

    timestamps(updated_at: false)
  end

  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:id, :webhook_id, :event_type, :payload, :response_status,
                    :response_body, :attempts, :delivered_at])
    |> validate_required([:id, :webhook_id, :event_type, :payload])
  end
end