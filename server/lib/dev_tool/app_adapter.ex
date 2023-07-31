defmodule DevTool.AppAdapter do
  @moduledoc """
    This adapter give ApplicationRunner the few function that he needs to work correctly.
  """
  @behaviour ApplicationRunner.Adapter

  alias DevTool.FakeHydra.OAuth2Helper
  alias DevTool.User
  alias DevTool.UserServices

  @impl ApplicationRunner.Adapter
  def allow(_user_id, _app_name) do
    :ok
  end

  @impl ApplicationRunner.Adapter
  def get_function_name(_app_name) do
    "test"
  end

  @impl ApplicationRunner.Adapter
  def get_env_id(_app_name) do
    1
  end

  @impl ApplicationRunner.Adapter
  def resource_from_params(%{"userId" => userId, "token" => token}) do
    userId
    |> Integer.parse()
    |> elem(0)
    |> do_resource_from_params(token)
  end

  def resource_from_params(%{"token" => token}) do
    do_resource_from_params(1, token)
  end

  def resource_from_params(_params) do
    raise "No token found. Please add a token to your websocket request."
  end

  defp do_resource_from_params(user_id, token) do
    with {:ok, _scope} <- OAuth2Helper.verify_scope(token, "app:websocket"),
         {:ok, %User{id: id}} <- UserServices.upsert_fake_user(user_id) do
      {:ok, id}
    end
  end
end
