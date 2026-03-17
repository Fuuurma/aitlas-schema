defmodule Aitlas.Schema.InstalledAgent do
  @moduledoc """
  User-installed agent with configuration and default status.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "installed_agents" do
    field(:user_id, :string)
    field(:agent_id, :binary_id)
    field(:installed_at, :utc_datetime)
    field(:version, :string)
    field(:is_default, :boolean, default: false)
    field(:config, :map, default: %{})

    belongs_to(:user, Aitlas.Schema.User, foreign_key: :user_id, define_field: false)
    belongs_to(:agent, Aitlas.Schema.Agent, foreign_key: :agent_id, define_field: false)

    timestamps()
  end

  def changeset(installed, attrs) do
    installed
    |> cast(attrs, [:user_id, :agent_id, :installed_at, :version, :is_default, :config])
    |> validate_required([:user_id, :agent_id])
    |> unique_constraint([:user_id, :agent_id])
  end
end
