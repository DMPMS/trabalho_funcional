defmodule TwitterClone.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :comments, TwitterClone.Timeline.Comment, on_delete: :nilify_all
    has_many :posts, TwitterClone.Timeline.Post, on_delete: :nilify_all

    belongs_to :user_role, TwitterClone.Accounts.UserRole,
      foreign_key: :role_key,
      type: :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role_key])
    |> validate_required([:username, :password, :role_key])
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if changeset.valid? do
      password = get_change(changeset, :password)
      hashed_password = Bcrypt.hash_pwd_salt(password)
      put_change(changeset, :password_hash, hashed_password)
    else
      changeset
    end
  end
end
