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
    UserData,
    Data,
    DataQueryViewServices
  }

  require Logger

  def get(env_id, ds_name, data_id) do
    DataQueryViewServices.get_one(env_id, ds_name, data_id)
    |> Repo.one()
  end

  def get_all(env_id, ds_name) do
    DataQueryViewServices.get_all(env_id, ds_name)
    |> Repo.all()
  end

  def exec_query(_env_id, _user_id, nil) do
    []
  end

  def exec_query(%AST.Query{} = query, env_id, user_id) do
    Logger.debug(query)

    user_data =
      ApplicationRunner.UserDataServices.current_user_data_query(env_id, user_id)
      |> Repo.one()

    query
    |> AST.EctoParser.to_ecto(env_id, user_data.id)
    |> Repo.all()
  end

  def parse_and_exec_query(query, env_id, user_id) do
    query
    |> AST.Parser.from_json()
    |> exec_query(env_id, user_id)
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
