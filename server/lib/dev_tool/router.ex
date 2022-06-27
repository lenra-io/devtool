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
    get(
      "/apps/00000000-0000-0000-0000-000000000000/resources/:resource",
      ResourcesController,
      :get_app_resource
    )
  end
end
