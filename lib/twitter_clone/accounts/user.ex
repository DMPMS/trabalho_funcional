defmodule TwitterClone.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
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
    |> cast(attrs, [:username, :password, :password_confirmation])
    |> validate_required([:username, :password], message: "Preencha este campo")

    |> validate_length(:username, min: 8, message: "Pelo menos 8 caracteres")
    |> validate_length(:password, min: 8, message: "Pelo menos 8 caracteres")

    |> validate_confirmation(:password, message: "As senhas não coincidem")
    |> unique_constraint(:username, message: "Nome de usuário em uso")
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
