defmodule TwitterCloneWeb.AuthErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl true
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> redirect(to: "/login")
    |> halt()
  end
end
