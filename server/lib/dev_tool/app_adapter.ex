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
  def resource_from_params(%{"userId" => user_id, "token" => token} = params) do
    user_id
    |> Integer.parse()
    |> elem(0)
    |> do_resource_from_params(token, params)
  end

  def resource_from_params(%{"token" => token} = params) do
    do_resource_from_params(1, token, params)
  end

  def resource_from_params(_params) do
    raise "No token found. Please add a token to your websocket request."
  end

  defp do_resource_from_params(user_id, token, params) do
    with {:ok, %{user: user_id}} <- OAuth2Helper.claims_from_verified_token(token, "app:websocket"),
         {:ok, %User{id: id}} <- UserServices.upsert_fake_user(user_id) do
      {:ok, id, "devtool-app", ApplicationRunner.AppSocket.extract_context(params)}
    end
  end
end
