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
  end
end
