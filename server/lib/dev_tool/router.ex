defmodule DevTool.Router do
  use DevTool, :router

  require ApplicationRunner.Router

  ApplicationRunner.Router.app_routes()

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DevTool do
    pipe_through([:api])
    post("/apps/:app_uuid/webhooks/:webhook_uuid", WebhooksController, :trigger)
  end

  scope "/api", DevTool do
    ApplicationRunner.Router.resource_route(ResourcesController)
  end

  scope "/", DevTool do
    post("/token", LenraTokenController, :generate)
  end
end
