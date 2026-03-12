defmodule AitlasSchema.Accounts.User do
  @moduledoc """
  User schema - canonical definition for all Aitlas projects.
  
  Convention: snake_case table and column names.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "users" do
    field :name, :string
    field :email, :string
    field :email_verified, :boolean, default: false
    field :image, :string
    
    # Credits
    field :compute_credits, :integer, default: 100
    field :plan_tier, Ecto.Enum, values: [:free, :pro, :enterprise], default: :free

    timestamps(inserted_at: :created_at)
    
    # Relations
    has_many :sessions, AitlasSchema.Accounts.Session
    has_many :accounts, AitlasSchema.Accounts.Account
    has_many :api_keys, AitlasSchema.Accounts.ApiKey
    has_many :tasks, AitlasSchema.Tasks.Task
    has_many :credit_ledger, AitlasSchema.Credits.LedgerEntry
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :email_verified, :image, :compute_credits, :plan_tier])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
  end
end

defmodule AitlasSchema.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "sessions" do
    field :user_id, :string
    field :expires_at, :utc_datetime

    timestamps(inserted_at: :created_at)
    
    belongs_to :user, AitlasSchema.Accounts.User
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_id, :expires_at])
    |> validate_required([:user_id, :expires_at])
    |> foreign_key_constraint(:user_id)
  end
end

defmodule AitlasSchema.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "accounts" do
    field :user_id, :string
    field :provider_type, :string
    field :provider_id, :string
    field :provider_account_id, :string

    timestamps(inserted_at: :created_at)
    
    belongs_to :user, AitlasSchema.Accounts.User
  end
end

defmodule AitlasSchema.Accounts.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "api_keys" do
    field :user_id, :string
    field :name, :string
    field :key_hash, :string
    field :prefix, :string
    field :last_used, :utc_datetime
    field :revoked, :boolean, default: false

    timestamps(inserted_at: :created_at)
    
    belongs_to :user, AitlasSchema.Accounts.User
  end
end