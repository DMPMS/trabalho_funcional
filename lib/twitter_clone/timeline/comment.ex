defmodule TwitterClone.Timeline.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :post, TwitterClone.Timeline.Post
    belongs_to :user, TwitterClone.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id, :user_id])
    |> validate_required([:body, :post_id], message: "Preencha este campo")
    
    |> validate_length(:body, min: 8, message: "Pelo menos 8 caracteres")
  end
end
