defmodule TwitterCloneWeb.SignupLive do
  use TwitterCloneWeb, :live_view
  alias TwitterClone.Accounts
  alias TwitterClone.Accounts.User

  def render(assigns) do
    ~L"""
    <div class="signup-container">
      <h2>Cadastro</h2>

      <%= if @error_message do %>
        <p class="error"><%= @error_message %></p>
      <% end %>

      <form phx-submit="signup">
        <label>Username:</label>
        <input type="text" name="username" required />

        <label>Senha:</label>
        <input type="password" name="password" required />

        <label>Confirmar Senha:</label>
        <input type="password" name="password_confirmation" required />

        <button type="submit">Cadastrar</button>
      </form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, error_message: nil)}
  end

  def handle_event(
        "signup",
        %{
          "username" => username,
          "password" => password,
          "password_confirmation" => password_confirmation
        },
        socket
      ) do
    if password != password_confirmation do
      {:noreply, assign(socket, error_message: "As senhas não coincidem")}
    else
      case Accounts.create_user(%{username: username, password: password}) do
        {:ok, _user} ->
          {:noreply, push_redirect(socket, to: "/login")}

        {:error, changeset} ->
          {:noreply, assign(socket, error_message: "Erro ao criar conta")}
      end
    end
  end
end
