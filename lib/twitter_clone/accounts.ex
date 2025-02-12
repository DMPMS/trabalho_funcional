defmodule TwitterClone.Accounts do
  import Ecto.Query, warn: false
  alias TwitterClone.Repo

  alias TwitterClone.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def authenticate_user(username, password) do
    user = get_user_by_username(username)

    case user do
      nil ->
        {:error, "Usuário não encontrado"}

      %User{} = user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, "Senha incorreta"}
        end
    end
  end
end
