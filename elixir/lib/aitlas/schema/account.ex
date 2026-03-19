defmodule Aitlas.Schema.Account do
  @moduledoc """
  Account schema for OAuth providers.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "accounts" do
    field(:user_id, :string)
    field(:account_id, :string)
    field(:provider_id, :string)
    field(:access_token, :string)
    field(:refresh_token, :string)
    field(:id_token, :string)
    field(:access_token_expires_at, :utc_datetime)
    field(:refresh_token_expires_at, :utc_datetime)
    field(:scope, :string)
    field(:password, :string)

    belongs_to(:user, Aitlas.Schema.User, foreign_key: :user_id, define_field: false)

    timestamps(inserted_at: :created_at)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :id,
      :user_id,
      :account_id,
      :provider_id,
      :access_token,
      :refresh_token,
      :id_token,
      :access_token_expires_at,
      :refresh_token_expires_at,
      :scope,
      :password
    ])
    |> validate_required([:id, :user_id, :account_id, :provider_id])
  end
end