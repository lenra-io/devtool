import Config

config :dev_tools, DevTool.Endpoint,
  http: [port: 4000],
  server: true

config :dev_tools,
  of_watchdog: System.fetch_env!("OF_WATCHDOG_BIN"),
  upstream_url: System.fetch_env!("OF_WATCHDOG_UPSTREAM_URL"),
  fprocess: System.fetch_env!("OF_WATCHDOG_F_PROCESS"),
  port: System.get_env("OF_WATCHDOG_PORT", "3333"),
  mode: System.get_env("OF_WATCHDOG_MODE", "http"),
  application_url: "http://localhost:#{System.get_env("OF_WATCHDOG_PORT", "3333")}"
