defmodule TwitterCloneWeb.CommentLive.FormComponent do
  use TwitterCloneWeb, :live_component

  alias TwitterClone.Timeline

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Timeline.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Timeline.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    comment_params =
      Map.merge(
        comment_params,
        %{"post_id" => socket.assigns.comment.post_id}
      )

    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_comment(socket, :edit, comment_params) do
    case Timeline.update_comment(socket.assigns.comment, comment_params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comentário atualizado sucesso")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_comment(socket, :new, comment_params) do
    case Timeline.create_comment(comment_params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comentário criado com sucesso")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
