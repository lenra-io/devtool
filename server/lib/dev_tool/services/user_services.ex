defmodule DevTool.UserServices do
  @moduledoc """
    The service that manages the environment
  """

  alias DevTool.{Repo, User}

  def upsert_fake_user(userId) do
    %{manual_id: userId, email: "user#{userId}@devtools.lenra.io"}
    |> User.new()
    |> Repo.insert(
      on_conflict: {:replace_all_except, [:id]},
      returning: true,
      conflict_target: [:manual_id]
    )
  end
end
