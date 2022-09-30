defmodule DevTool.Router do
  use DevTool, :router

  require ApplicationRunner.Router

  ApplicationRunner.Router.app_routes()

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DevTool do
    get("/", IndexController, :index)
  end

  scope "/api", DevTool do
    ApplicationRunner.Router.resource_route(ResourcesController)

    get("/webhooks", WebhooksController, :index)
    post("/webhooks", WebhooksController, :api_create)
  end
end
