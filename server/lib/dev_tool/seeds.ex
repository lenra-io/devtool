defmodule DevTool.Seeds do
  @moduledoc """
  Module to populate the database. The "run" function must be idempotent.
  """
  alias DevTool.{
    EnvironmentServices,
    Repo,
    UserServices
  }

  def run do
    Ecto.Migrator.with_repo(Repo, fn _ ->
      EnvironmentServices.create_first_env_if_not_exists()
    end)
  end
end
