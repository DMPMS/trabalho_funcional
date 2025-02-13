defmodule TwitterClone.Repo.Migrations.RenameUsernameToTitleFromPosts do
  use Ecto.Migration

  def change do
    rename table(:posts), :username, to: :title
  end
end
