defmodule DevTool.UserSocket do
  use ApplicationRunner.UserSocket, channel: DevTool.AppChannel

  alias DevTool.{User, UserServices}

  defp resource_from_params(%{"userId" => userId}) do
    userId
    |> Integer.parse()
    |> elem(0)
    |> do_resource_from_params()
  end

  defp resource_from_params(_params) do
    do_resource_from_params(1)
  end

  defp do_resource_from_params(userId) do
    case UserServices.upsert_fake_user(userId) do
      {:ok, %User{id: id}} ->
        {:ok, id}

      err ->
        err
    end
  end
end
