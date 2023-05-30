defmodule DevTool.ClientRouter do
  @moduledoc """
  The router for the client.
  """
  use DevTool, :router

  scope "/", DevTool do
    get("/*path", IndexController, :index)
  end
end
