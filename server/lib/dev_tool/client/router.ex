defmodule DevTool.Client.Router do
  @moduledoc """
  The router for the client.
  """
  use DevTool, :router

  scope "/", DevTool.Client do
    get("/*path", IndexController, :index)
  end
end
