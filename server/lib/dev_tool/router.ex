defmodule DevTool.Router do
  use DevTool, :router

  scope "/", DevTool do
    get("/", IndexController, :index)
  end

  scope "/api", DevTool do
    get("/apps/test/resources/:resource", ResourcesController, :get_app_resource)
  end

  scope "/app", DevTool do
    post("/datastore", DatastoreController, :create)
    delete("/datastore/:datastore", DatastoreController, :delete)
  end
end
