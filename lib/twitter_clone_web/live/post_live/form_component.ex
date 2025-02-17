defmodule TwitterCloneWeb.PostLive.FormComponent do
  use TwitterCloneWeb, :live_component

  alias TwitterClone.Timeline

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Timeline.change_post(post)
    remaining_chars = String.length(post.body || "")

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:remaining_chars, remaining_chars)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Timeline.change_post(post_params)
      |> Map.put(:action, :validate)

    remaining_chars = String.length(post_params["body"] || "")

    {:noreply, assign(socket, changeset: changeset, remaining_chars: remaining_chars)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Timeline.update_post(socket.assigns.post, post_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_post(socket, :new, post_params) do
    user = socket.assigns.current_user
    # Garante que o user_id está presente nos parâmetros
    post_params = Map.put(post_params, "user_id", user.id)

    case Timeline.create_post(post_params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post criado com sucesso!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
