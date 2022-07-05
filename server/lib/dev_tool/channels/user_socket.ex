defmodule DevTool.UserSocket do
  use ApplicationRunner.UserSocket, channel: DevTool.AppChannel

  alias DevTool.{Repo, User}

  defp resource_from_params(%{"fakeUser" => fake_user}) do
    case Repo.get(User, 1) do
      %User{} -> {:ok, 1}
      _err -> :error
    end
  end
end
