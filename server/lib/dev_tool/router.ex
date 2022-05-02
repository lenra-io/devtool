defmodule DevTool.Router do
  use DevTool, :router

  scope "/", DevTool do
    get("/", IndexController, :index)
  end

  scope "/api", DevTool do
    get("/apps/test/resources/:resource", ResourcesController, :get_app_resource)
  end

  scope "/app", DevTool do
    post("/datastores", DatastoreController, :create)
    delete("/datastores/:datastore", DatastoreController, :delete)
    get("/datastores/:_datastore/data/:_id", DataController, :get)
    get("/datastores/:_datastore/data", DataController, :get_all)
    post("/datastores/:_datastore/data", DataController, :create)
    delete("/datastores/:_datastore/data/:_id", DataController, :delete)
    put("/datastores/:_datastore/data/:_id", DataController, :update)
    post("/query", DataController, :query)
  end
end
