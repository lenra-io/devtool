defmodule DevTool.WebhooksController do
  use DevTool, :controller

  alias ApplicationRunner.Webhooks.WebhookServices
  alias DevTool.AppAdapter

  def index(conn, %{"user_id" => user_id} = _params) do
    conn
    |> reply(WebhookServices.get(AppAdapter.get_env_id(""), user_id))
  end

  def index(conn, _params) do
    conn
    |> reply(WebhookServices.get(AppAdapter.get_env_id("")))
  end

  def api_create(conn, params) do
    with {:ok, webhook} <- WebhookServices.create(AppAdapter.get_env_id(""), params) do
      conn
      |> reply(webhook)
    end
  end
end
