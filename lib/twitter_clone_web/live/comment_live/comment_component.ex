defmodule TwitterCloneWeb.CommentLive.CommentComponent do
  use TwitterCloneWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="comment-<%= @comment.id %>" style="padding: 10px; border: 1px solid #cccccc; max-width: 1000px;">
      <div style="display: flex; align-items: flex-start; gap: 10px;">
        <img src="https://png.pngtree.com/png-vector/20190710/ourlarge/pngtree-user-vector-avatar-png-image_1541962.jpg" width="50">
        <div>
          <text style="font-weight: 700; color: #1da1f2;">@<%= @comment.body %></text>
          <p style="font-size: 14px;"><%= @comment.post_id %></p>
        </div>
      </div>

      <div style="display: flex; gap: 10px;">
        <%= live_patch to: Routes.comment_index_path(@socket, :edit, @comment.post_id, @comment.id) do %>
          <div style="cursor: pointer; color: #1da1f2; font-size: 14px;">Editar</div>
        <% end %>
        <%= link to: "#", phx_click: "delete", phx_value_id: @comment.id, data: [confirm: "Tem certeza?"] do %>
          <div style="cursor: pointer; color: #1da1f2; font-size: 14px;">Remover</div>
        <% end %>
      </div>
    </div>
    """
  end
end
