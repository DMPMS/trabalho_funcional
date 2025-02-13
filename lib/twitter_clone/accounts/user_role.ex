defmodule TwitterClone.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:role_key, :string, []}
  schema "user_roles" do
    field :description, :string
    field :role_name, :string
    has_many :users, TwitterClone.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:role_key, :role_name, :description])
    |> validate_required([:role_key, :role_name])
    |> validate_length(:role_key, is: 1)
    |> unique_constraint(:role_key)
    |> unique_constraint(:role_name)
  end
end
