defmodule AitlasSchema.Tasks.Task do
  @moduledoc """
  Task schema - canonical definition for all Aitlas projects.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "tasks" do
    field :user_id, :string
    field :agent_id, :string
    field :status, Ecto.Enum, values: [:pending, :running, :completed, :failed, :cancelled], default: :pending
    field :prompt, :string
    field :result, :string
    field :error, :string
    field :completed_at, :utc_datetime

    timestamps(inserted_at: :created_at)
    
    belongs_to :user, AitlasSchema.Accounts.User
    has_many :steps, AitlasSchema.Tasks.TaskStep
    has_many :tool_calls, AitlasSchema.Tasks.ToolCall
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:user_id, :agent_id, :status, :prompt, :result, :error, :completed_at])
    |> validate_required([:user_id, :prompt])
    |> foreign_key_constraint(:user_id)
  end
end

defmodule AitlasSchema.Tasks.TaskStep do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "task_steps" do
    field :task_id, :string
    field :step_number, :integer
    field :action, :string
    field :input, :string
    field :output, :string

    timestamps(inserted_at: :created_at)
    
    belongs_to :task, AitlasSchema.Tasks.Task
  end
end

defmodule AitlasSchema.Tasks.ToolCall do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "tool_calls" do
    field :task_id, :string
    field :tool_name, :string
    field :arguments, :string
    field :result, :string

    timestamps(inserted_at: :created_at)
    
    belongs_to :task, AitlasSchema.Tasks.Task
  end
end