defmodule TwitterCloneWeb.PostLive.PostComponent do
    use TwitterCloneWeb, :live_component
  
    def render(assigns) do
      ~L"""
      <div id="post-<%= @post.id %>" style="padding: 10px; border: 1px solid #cccccc; max-width: 1000px;">
        <div style="display: flex; align-items: flex-start; gap: 10px;">
          <img src="https://png.pngtree.com/png-vector/20190710/ourlarge/pngtree-user-vector-avatar-png-image_1541962.jpg" width="50">
          <div>
            <text style="font-weight: 700; color: #1da1f2;">@<%= @post.username %></text>
            <p style="font-size: 14px;"><%= @post.body %></p>
          </div>
        </div>
  
        <div style="display: flex; justify-content: space-between;">
            <div phx-click="like" phx-target="<%= @myself %>" style="cursor: pointer; color: #1da1f2; font-size: 14px;">Curtir <%= @post.likes_count %></div>
            <div phx-click="repost" phx-target="<%= @myself %>" style="cursor: pointer; color: #1da1f2; font-size: 14px;">Repostar <%= @post.reposts_count %></div>
          <div style="display: flex; gap: 10px;">
            <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
                <div style="cursor: pointer; color: #1da1f2; font-size: 14px;">Editar</div>
            <% end %>
            <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Tem certeza?"] do %>
                <div style="cursor: pointer; color: #1da1f2; font-size: 14px;">Remover</div>
            <% end %>
          </div>
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
  