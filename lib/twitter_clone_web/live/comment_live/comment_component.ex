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
    </div>
    """
  end
end
