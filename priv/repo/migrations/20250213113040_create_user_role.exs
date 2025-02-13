defmodule TwitterClone.Repo.Migrations.CreateUserRole do
  use Ecto.Migration

  def change do
    create table(:user_roles, primary_key: false) do
      add :role_key, :string, primary_key: true, size: 1
      add :role_name, :string, null: false
      add :description, :string, null: true

      timestamps()
    end
  end
end
