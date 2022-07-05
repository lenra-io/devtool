defmodule DevTool.Repo.Migrations.NoAutoIncrementUserId do
  use Ecto.Migration

  def change do
    # alter table(:users) do
    #   modify(:id, :bigint)
    # end
    # Drop the old user table and all foreign key/view/constraints associated with it
    drop_if_exists table(:users), mode: :cascade
    # Recreate the table without the auto incremen tprimary key
    create table(:users,  primary_key: false) do
      add(:id, :id, primary_key: true, null: false)
      add(:email, :string, null: false)
      timestamps()
    end

    create(unique_index(:users, [:email], name: :unique_user_email))
    create(unique_index(:users, [:id], name: :unique_user_id))

    # Recreate the foreigh key/views/constraints
    alter table(:user_datas) do
      modify(:user_id, references(:users), null: false)
    end


    execute("
    CREATE VIEW data_query_view AS
    SELECT
    d.id as id,
    ds.environment_id as environment_id,
    to_jsonb(d.data) ||
    jsonb_build_object(
      '_datastore', ds.name,
      '_id', d.id,
      '_refs', (SELECT COALESCE((SELECT jsonb_agg(dr.refs_id) FROM data_references as dr where ref_by_id = d.id GROUP BY dr.ref_by_id), '[]'::jsonb)),
      '_refBy', (SELECT COALESCE((SELECT jsonb_agg(dr.ref_by_id) FROM data_references as dr where refs_id = d.id GROUP BY dr.refs_id), '[]'::jsonb))
    ) ||
    CASE  WHEN ds.name != '_users' THEN '{}'::jsonb
          WHEN ds.name = '_users' THEN jsonb_build_object(
            '_user', (SELECT to_jsonb(_) FROM (SELECT u.email, u.id) AS _)
          )
    END
    as data
      FROM datas AS d
      INNER JOIN datastores AS ds ON (ds.id = d.datastore_id)
      LEFT JOIN user_datas AS ud ON (ud.data_id = d.id)
      LEFT JOIN users AS u ON (u.id = ud.user_id);
    ",  "DROP VIEW IF EXISTS data_query_view")
  end

end
