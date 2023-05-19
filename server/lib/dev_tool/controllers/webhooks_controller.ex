defmodule DevTool.WebhooksController do
  use DevTool, :controller

  alias ApplicationRunner.Webhooks.WebhookServices
  alias DevTool.Errors.BusinessError

  require Logger

  def trigger(conn, %{"webhook_uuid" => webhook_uuid} = _params) do
    Logger.debug(
      "#{__MODULE__} handle #{inspect(conn.method)} on #{inspect(conn.request_path)} with path_params #{inspect(conn.path_params)} and body_params #{inspect(conn.body_params)}"
    )

    conn
    |> reply(WebhookServices.trigger(webhook_uuid, conn.body_params))
  end

  def trigger(_conn, params) do
    Logger.error(BusinessError.null_parameters(params))
    BusinessError.null_parameters_tuple(params)
  end
end
