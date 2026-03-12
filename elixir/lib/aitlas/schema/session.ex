defmodule Aitlas.Schema.Session do
  @moduledoc """
  Session schema for user authentication.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "sessions" do
    field(:user_id, :string)
    field(:token, :string)
    field(:expires_at, :utc_datetime)
    field(:ip_address, :string)
    field(:user_agent, :string)

    belongs_to(:user, Aitlas.Schema.User, foreign_key: :user_id, define_field: false)

    timestamps()
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:id, :user_id, :token, :expires_at, :ip_address, :user_agent])
    |> validate_required([:id, :user_id, :token, :expires_at])
    |> unique_constraint(:token)
  end
end