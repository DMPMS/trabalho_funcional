defmodule TwitterCloneWeb.SessionController do
  use TwitterCloneWeb, :controller

  def new(conn, _params) do
    # Exibe o formulário de login
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case TwitterClone.Accounts.authenticate_user(username, password) do
      {:ok, user} ->
        case TwitterClone.Guardian.encode_and_sign(user) do
          {:ok, token, _claims} ->
            conn
            # <- 🔥 Garante que o token é salvo corretamente
            |> Guardian.Plug.sign_in(TwitterClone.Guardian, user)
            |> put_session(:token, token)
            |> put_flash(:info, "Login efetuado com sucesso!")
            |> redirect(to: Routes.post_index_path(conn, :index))

          {:error, _reason} ->
            conn
            |> put_flash(:error, "Erro ao gerar token.")
            |> render("new.html")
        end

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Email ou senha inválidos!")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
