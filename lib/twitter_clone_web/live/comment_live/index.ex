defmodule TwitterCloneWeb.CommentLive.Index do
  use TwitterCloneWeb, :live_view

  alias TwitterClone.Timeline
  alias TwitterClone.Timeline.Comment

  @impl true
  def mount(%{"post_id" => post_id}, _session, socket) do
    comments = list_comments(post_id)
    {:ok, assign(socket, comments: comments, post_id: post_id)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Comment")
    |> assign(:comment, Timeline.get_comment!(id))
  end

  defp apply_action(socket, :new, %{"post_id" => post_id}) do
    IO.puts(post_id)

    socket
    |> assign(:page_title, "Novo Comentario")
    |> assign(:comment, %Comment{})
  end

  defp apply_action(socket, :index, %{"post_id" => post_id}) do
    socket
    |> assign(:page_title, "Listing Comments")
    |> assign(:comments, list_comments(post_id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comment = Timeline.get_comment!(id)
    {:ok, _} = Timeline.delete_comment(comment)

    {:noreply, assign(socket, :comments, list_comments(socket.assigns.post_id))}
  end

  defp list_comments(post_id) do
    Timeline.list_comments(post_id)
  end
end
