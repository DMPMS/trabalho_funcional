defmodule TwitterCloneWeb.AuthLive do
  use TwitterCloneWeb, :live_view
  alias TwitterClone.Accounts

  def render(assigns) do
    ~L"""
    <div class="login-container">
      <h2>Login</h2>

      <%= if @error_message do %>
        <p class="error"><%= @error_message %></p>
      <% end %>

      <form phx-submit="login">
        <label>Username:</label>
        <input type="text" name="username" required />

        <label>Senha:</label>
        <input type="password" name="password" required />

        <button type="submit">Entrar</button>
      </form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, error_message: nil)}
  end

  def handle_event("login", %{"username" => username, "password" => password}, socket) do
    case Accounts.authenticate_user(username, password) do
      {:ok, user} ->
        {:noreply, push_redirect(socket, to: "/dashboard")}

      {:error, msg} ->
        {:noreply, assign(socket, error_message: msg)}
    end
  end

  # def handle_event("logout", _, socket) do
  #   {:noreply, socket |> clear_session() |> push_redirect(to: "/login")}
  # end
end
