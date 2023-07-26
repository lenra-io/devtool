defmodule DevTool.AppAdapter do
  @moduledoc """
    This adapter give ApplicationRunner the few function that he needs to work correctly.
  """
  @behaviour ApplicationRunner.Adapter

  alias DevTool.User
  alias DevTool.UserServices
  alias DevTool.FakeHydra.OAuth2Helper

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
    with {:ok, _scope} <- OAuth2Helper.verify_scope(token, "app:websocket") do
      userId
      |> Integer.parse()
      |> elem(0)
      |> do_resource_from_params()
    end
  end

  def resource_from_params(_params) do
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
