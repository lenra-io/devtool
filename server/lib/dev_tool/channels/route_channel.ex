defmodule DevTool.RouteChannel do
  @moduledoc """
    `LenraWeb.AppChannel` handle the app channel to run app and listeners and push to the user the resulted UI or Patch
  """
  use ApplicationRunner.RouteChannel
end
