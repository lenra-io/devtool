defmodule DevTool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DevTool.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DevTool.PubSub},
      # Start the Endpoint (http/https)
      DevTool.Endpoint,
      # Start the watchdog handler server
      {DevTool.Watchdog,
       of_watchdog: "/Users/louis/Documents/lenra/dev-tools/server/node12/of-watchdog",
       upstream_url: "http://127.0.0.1:3000",
       fprocess: "node node12/index.js",
       port: "3333",
       mode: "http"},
      {Finch, name: AppHttp}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DevTool.Supervisor]

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DevTool.Endpoint.config_change(changed, removed)
    :ok
  end
end
