defmodule TwitterCloneWeb.UserController do
  use TwitterCloneWeb, :controller

  alias TwitterClone.Accounts
  alias TwitterClone.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    user_params = Map.put_new(user_params, "role_key", "U")
    
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Usuário cadastrado com sucesso!")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
