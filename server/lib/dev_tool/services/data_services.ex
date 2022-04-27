defmodule DevTool.DataServices do
  @moduledoc """
    The service that manages application data.
  """
  import Ecto.Query, only: [from: 2]

  alias DevTool.Repo

  alias ApplicationRunner.{
    AST,
    Data,
    DataServices,
    Datastore,
    UserData
  }

  require Logger

  def get(ds_name, id) do
    select =
      from(d in Data,
        join: ds in Datastore,
        on: d.datastore_id == ds.id,
        where: d.id == ^id and ds.name == ^ds_name,
        select: d
      )

    select
    |> Repo.one()
  end

  def query(_env_id, _user_id, nil) do
    []
  end

  def query(env_id, user_id, %AST.Query{} = query) do
    Logger.debug(query)

    user_data =
      ApplicationRunner.UserDataServices.current_user_data_query(env_id, user_id)
      |> Repo.one()

    query
    |> AST.EctoParser.to_ecto(env_id, user_data.id)
    |> Repo.all()
  end

  def create(environment_id, params) do
    environment_id
    |> DataServices.create(params)
    |> Repo.transaction()
  end

  def create_and_link(user_id, environment_id, params) do
    environment_id
    |> DataServices.create(params)
    |> Ecto.Multi.run(:user_data, fn repo, %{inserted_data: %Data{} = data} ->
      repo.insert(UserData.new(%{user_id: user_id, data_id: data.id}))
    end)
    |> Repo.transaction()
  end

  def update(params) do
    DataServices.update(params)
    |> Repo.transaction()
  end

  def delete(data_id) do
    data_id
    |> DataServices.delete()
    |> Repo.transaction()
  end
end
