defmodule TwitterCloneWeb.PostLive.Index do
  use TwitterCloneWeb, :live_view

  alias TwitterClone.Timeline
  alias TwitterClone.Timeline.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Timeline.subscribe()

    posts = list_posts()
    {:ok, assign(socket, :posts, posts)}
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
    IO.inspect(updated_post, label: "🚀 Evento post_updated recebido")

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
end
