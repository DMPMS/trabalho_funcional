defmodule TwitterCloneWeb.PostLive.PostComponent do
  use TwitterCloneWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="post-<%= @post.id %>" class="bg-white p-6 border border-gray-300 rounded-xl">
      <div class="flex items-start gap-4 mb-4">
        <img src="https://png.pngtree.com/png-vector/20190710/ourlarge/pngtree-user-vector-avatar-png-image_1541962.jpg" class="w-12 h-12 rounded-full">
        <div>
          <text class="text-sm font-medium text-blue-500">@<%= @user_name %></text>
          <p class="text-lg"><%= @post.title %></p>
          <p class="text-sm text-gray-700"><%= @post.body %></p>
        </div>
      </div>

      <div class="flex flex-wrap justify-between">
        <div phx-click="like" phx-target="<%= @myself %>" class="cursor-pointer text-blue-500 text-sm">
          Curtir <%= @post.likes_count %>
        </div>
        <div phx-click="repost" phx-target="<%= @myself %>" class="cursor-pointer text-blue-500 text-sm">
          Repostar <%= @post.reposts_count %>
        </div>
        <div class="cursor-pointer text-blue-500 text-sm">
          <%= live_patch to: Routes.comment_index_path(@socket, :index, @post.id) do %>
            <div class="cursor-pointer text-blue-500 text-sm">
              Comentários <%= @comments_count %>
            </div>
          <% end %>
        </div>
        <%= if @user_name == @user_logged_username do %>
          <div class="flex gap-4">
            <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
              <div class="cursor-pointer text-blue-500 text-sm">Editar</div>
            <% end %>
            <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Tem certeza?"] do %>
              <div class="cursor-pointer text-red-500 text-sm">Remover</div>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("like", _, socket) do
    TwitterClone.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end

  def handle_event("repost", _, socket) do
    TwitterClone.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
