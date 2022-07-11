defmodule DevTool.Repo.Migrations.NoAutoIncrementUserId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :manual_id, :id, null: false
    end

    create(unique_index(:users, [:manual_id], name: :unique_user_manual_id))
  end
end
