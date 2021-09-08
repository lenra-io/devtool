defmodule DevTool.Router do
  use DevTool, :router

  scope "/", DevTool do
    get("/", IndexController, :index)
  end
end
