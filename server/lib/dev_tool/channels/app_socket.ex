defmodule DevTool.AppSocket do
  use ApplicationRunner.AppSocket,
    adapter: DevTool.AppAdapter,
    route_channel: DevTool.RouteChannel,
    routes_channel: DevTool.RoutesChannel
end
