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
    get("/datastore/:_datastore/data/:_id", DataController, :get)
    get("/datastore/:_datastore/data", DataController, :get_all)
    post("/datastore/:_datastore/data", DataController, :create)
    delete("/datastore/:_datastore/data/:_id", DataController, :delete)
    put("/datastore/:_datastore/data/:_id", DataController, :update)
    post("/query", DataController, :query)
  end
end
