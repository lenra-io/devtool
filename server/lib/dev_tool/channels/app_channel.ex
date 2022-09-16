defmodule DevTool.AppChannel do
  @moduledoc """
    `LenraWeb.AppChannel` handle the app channel to run app and listeners and push to the user the resulted UI or Patch
  """
  use ApplicationRunner.AppChannel, adapter: DevTool.AppAdapter
end
