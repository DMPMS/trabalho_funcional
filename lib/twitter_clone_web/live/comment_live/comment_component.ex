defmodule TwitterCloneWeb.CommentLive.CommentComponent do
  use TwitterCloneWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="comment-<%= @comment.id %>" class="bg-white p-6 border border-gray-300 rounded-xl">
      <div class="flex items-start gap-4 mb-4">
        <img src="https://png.pngtree.com/png-vector/20190710/ourlarge/pngtree-user-vector-avatar-png-image_1541962.jpg" class="w-12 h-12 rounded-full">
        <div>
          <text class="text-sm font-medium text-blue-500">@<%= @user_name %></text>
          <p class="text-sm text-gray-700"><%= @comment.body %></p>
        </div>
      </div>

      <div class="flex justify-end">
        <div class="flex gap-4">
          <%= live_patch to: Routes.comment_index_path(@socket, :edit, @comment.post_id, @comment.id) do %>
            <div class="cursor-pointer text-blue-500 text-sm">Editar</div>
          <% end %>
          <%= link to: "#", phx_click: "delete", phx_value_id: @comment.id, data: [confirm: "Tem certeza?"] do %>
            <div class="cursor-pointer text-red-500 text-sm">Remover</div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
