defmodule TwitterClone.Repo.Migrations.AddedUserIdInCommentTable do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :user_id, references(:users, on_delete: :nilify_all)
    end
  end
end
