defmodule TwitterCloneWeb.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  alias TwitterClone.Guardian
  alias TwitterCloneWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _opts) do
    if Guardian.Plug.authenticated?(conn) do
      user = Guardian.Plug.current_resource(conn)
      assign(conn, :current_user, user)
    else
      conn
      |> Guardian.Plug.sign_out(TwitterClone.Guardian)
      |> put_flash(:error, "Sua sessão expirou, faça login novamente.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
