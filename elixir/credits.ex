defmodule AitlasSchema.Credits.LedgerEntry do
  @moduledoc """
  Credit ledger entry - tracks credit transactions.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "credit_ledger" do
    field :user_id, :string
    field :delta, :integer
    field :balance, :integer
    field :reason, :string
    field :task_id, :string

    timestamps(inserted_at: :created_at)
    
    belongs_to :user, AitlasSchema.Accounts.User
  end

  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:user_id, :delta, :balance, :reason, :task_id])
    |> validate_required([:user_id, :delta, :balance, :reason])
    |> foreign_key_constraint(:user_id)
  end
end