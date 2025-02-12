defmodule TwitterCloneWeb.CommentLive.Index do
  use TwitterCloneWeb, :live_view

  alias TwitterClone.Timeline
  alias TwitterClone.Timeline.Comment

  @impl true
  def mount(%{"post_id" => post_id}, _session, socket) do
    comments = list_comments(post_id)

    {:ok,
     assign(socket,
       comments: comments,
       post_id: post_id
     ), temporary_assigns: [comments: []]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Comentário")
    |> assign(:comment, Timeline.get_comment!(id))
  end

  defp apply_action(socket, :new, %{"post_id" => post_id}) do
    socket
    |> assign(:page_title, "Novo Comentario")
    |> assign(:comment, %Comment{post_id: post_id})
  end

  defp apply_action(socket, :index, %{"post_id" => post_id}) do
    socket
    |> assign(:page_title, "Lista de Comentários")
    |> assign(:comments, list_comments(post_id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comment = Timeline.get_comment!(id)

    case Timeline.delete_comment(comment) do
      {:ok, _} ->
        comments = list_comments(socket.assigns.post_id)
        {:noreply, assign(socket, :comments, comments)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  defp list_comments(post_id) do
    Timeline.list_comments(post_id)
  end
end
