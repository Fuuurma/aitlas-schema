defmodule Nexus.Schema.AuditLog do
  @moduledoc """
  Audit log entry.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "audit_logs" do
    field(:user_id, :string)
    field(:action, :string)
    field(:resource_type, :string)
    field(:resource_id, :string)
    field(:old_values, :map)
    field(:new_values, :map)
    field(:ip_address, :string)
    field(:user_agent, :string)

    timestamps(updated_at: false)
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [:id, :user_id, :action, :resource_type, :resource_id,
                    :old_values, :new_values, :ip_address, :user_agent])
    |> validate_required([:id, :action])
  end
end