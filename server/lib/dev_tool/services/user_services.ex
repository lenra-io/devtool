defmodule DevTool.UserServices do
  @moduledoc """
    The service that manages the environment
  """

  import Ecto.Query, only: [from: 2]
  alias DevTool.{Repo, User}

  def upsert_fake_user(userId) do
    %{id: userId, email: "user#{userId}@devtools.lenra.io"}
    |> User.new()
    |> Repo.insert(on_conflict: :replace_all, returning: true, conflict_target: [:id])
  end
end
