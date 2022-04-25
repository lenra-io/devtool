defmodule DevTool.Router do
  use DevTool, :router

  scope "/", DevTool do
    get("/", IndexController, :index)
  end

  scope "/api", DevTool do
    get("/apps/test/resources/:resource", ResourcesController, :get_app_resource)
  end

  scope "/app", DevTool do
    get("/datastore/:datastore/data/:id", DataController, :get)
    post("/datastore/:datastore/data", DataController, :create)
    delete("/datastore/:datastore/data/:id", DataController, :delete)
    put("/datastore/:datastore/data/:id", DataController, :update)
  end
end
