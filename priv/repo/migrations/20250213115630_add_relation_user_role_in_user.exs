defmodule TwitterClone.Repo.Migrations.AddRelationUserRoleInUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role_key,
          references(:user_roles, column: :role_key, type: :string, on_delete: :nothing)
    end

    create index(:users, [:role_key])
  end
end
