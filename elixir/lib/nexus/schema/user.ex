defmodule Nexus.Schema.User do
  @moduledoc """
  User schema for Aitlas accounts.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:email_verified, :boolean, default: false)
    field(:image, :string)
    field(:compute_credits, :integer, default: 100)
    field(:plan_tier, :string, default: "free")

    has_many(:sessions, Nexus.Schema.Session)
    has_many(:accounts, Nexus.Schema.Account)
    has_many(:api_keys, Nexus.Schema.ApiKey)
    has_many(:tasks, Nexus.Schema.Task)
    has_many(:credit_ledger_entries, Nexus.Schema.CreditLedgerEntry)

    timestamps(inserted_at: :created_at)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :name, :email, :email_verified, :image, :compute_credits, :plan_tier])
    |> validate_required([:id, :name, :email])
    |> unique_constraint(:email)
  end
end
