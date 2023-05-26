defmodule DevTool.ClientRouter do
  use DevTool, :router

  scope "/", DevTool do
    get("/*path", IndexController, :index)
  end
end
