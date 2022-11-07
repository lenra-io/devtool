defmodule DevTool.AppSocket do
  use ApplicationRunner.AppSocket,
    adapter: DevTool.AppAdapter,
    route_channel: DevTool.RouteChannel
end
