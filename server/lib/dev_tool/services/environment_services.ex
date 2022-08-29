defmodule DevTool.EnvironmentServices do
  @moduledoc """
    The service that manages the environment
  """

  import Ecto.Query, only: [from: 2]
  alias ApplicationRunner.JsonStorage.Datastore

  alias DevTool.{
    Environment,
    Repo
  }

  def get_first_env! do
    first_env_query()
    |> Repo.one!()
  end

  def create_first_env_if_not_exists do
    if not (first_env_query() |> Repo.exists?()) do
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:inserted_environment, Environment.new())
      # |> Ecto.Multi.insert(:inserted_user_data_datastore, fn %{inserted_environment: env} ->
      #   Datastore.new(env.id, %{name: "_users"})
      # end)
      |> Repo.transaction()
    end
  end

  defp first_env_query, do: from(Environment, limit: 1)
end
