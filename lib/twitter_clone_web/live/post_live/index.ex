defmodule TwitterCloneWeb.PostLive.Index do
  use TwitterCloneWeb, :live_view

  alias TwitterClone.Timeline
  alias TwitterClone.Timeline.Post
  alias TwitterClone.Guardian

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Timeline.subscribe()
    user = get_current_user(session) |> elem(1)

    if user do
      posts = list_posts()
      {:ok, assign(socket, current_user: user, posts: posts)}
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
    |> assign(:page_title, "Editar Publicação")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nova Publicação")
    |> assign(:post, %Post{})
    |> assign(:current_user, socket.assigns.current_user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Publicações")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  # def handle_info({:post_deleted, post}, socket) do
  #   {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  # end

  @impl true
  def handle_info({:post_updated, updated_post}, socket) do
    updated_posts =
      Enum.map(socket.assigns.posts, fn post ->
        if post.id == updated_post.id do
          updated_post
        else
          post
        end
      end)

    {:noreply, assign(socket, :posts, updated_posts)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)

    case Timeline.delete_post(post) do
      {:ok, _} ->
        {:noreply, assign(socket, :posts, list_posts())}

      {:error, _reason} ->
        # Se der erro, mantém o socket sem mudanças
        {:noreply, socket}
    end
  end

  defp list_posts do
    Timeline.list_posts()
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
