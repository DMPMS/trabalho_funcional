defmodule TwitterCloneWeb.CommentLive.Index do
  use TwitterCloneWeb, :live_view

  alias TwitterClone.Timeline
  alias TwitterClone.Timeline.Comment
  alias TwitterClone.Guardian

  @impl true
  def mount(%{"post_id" => post_id}, session, socket) do
    if connected?(socket), do: Timeline.subscribe_comments()
    user = get_current_user(session) |> elem(1)

    if user do
      post = Timeline.get_post!(post_id)
      comments = list_comments(post_id)
      {:ok, assign(socket, comments: comments, current_user: user, post_id: post_id, post_title: post.title, post_user_id: post.user_id)}
    else
      {:ok, redirect(socket, to: "/logout")}
    end
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
    |> assign(:page_title, "Novo Comentário")
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

  @impl true
  def handle_info({:comment_created, comment}, socket) do
    # Apenas atualiza se o comentário pertence ao post visível
    if comment.post_id == String.to_integer(socket.assigns.post_id) do
      # Adiciona o novo comentário na lista
      comments = [comment | socket.assigns.comments]
      {:noreply, assign(socket, :comments, comments)}
    else
      {:noreply, socket}
    end
  end

  defp list_comments(post_id) do
    Timeline.list_comments(post_id)
  end

  defp get_current_user(session) do
    case session["token"] do
      nil ->
        nil

      token ->
        case Guardian.decode_and_verify(token) do
          {:ok, claims} -> Guardian.resource_from_claims(claims)
          _ -> nil
        end
    end
  end
end
