defmodule TwitterClone.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :likes_count, :integer, default: 0
    field :reposts_count, :integer, default: 0
    field :title, :string
    has_many :comments, TwitterClone.Timeline.Comment, on_delete: :delete_all
    belongs_to :user, TwitterClone.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :title, :user_id])
    |> validate_required([:body, :title, :user_id])
    |> validate_length(:body, min: 8, max: 250)
  end
end
