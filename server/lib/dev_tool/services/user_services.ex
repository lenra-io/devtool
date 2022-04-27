defmodule DevTool.UserServices do
  @moduledoc """
    The service that manages the environment
  """

  import Ecto.Query, only: [from: 2]
  alias DevTool.{Repo, User}

  def get_first_user!() do
    first_user_query()
    |> Repo.one!()
  end

  def create_first_user_if_not_exists() do
    if not (first_user_query() |> Repo.exists?()) do
      Repo.insert(User.new(%{email: "devtool@lenra.io"}))
    end
  end

  defp first_user_query(), do: from(User, limit: 1)
end
