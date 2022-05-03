import Config

config :dev_tools, DevTool.Endpoint,
  http: [port: 4000],
  server: true

config :dev_tools,
  of_watchdog: System.fetch_env!("OF_WATCHDOG_BIN"),
  port: System.get_env("OF_WATCHDOG_PORT", "8080"),
  application_url: "http://localhost:#{System.get_env("OF_WATCHDOG_PORT", "8080")}"
