import Config

config :dev_tools, DevTool.Endpoint,
  http: [port: 4000],
  server: true

config :dev_tools, DevTool.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DB"),
  hostname: System.get_env("POSTGRES_HOST")

config :dev_tools,
  of_watchdog: System.fetch_env!("OF_WATCHDOG_BIN"),
  port: System.get_env("OF_WATCHDOG_PORT", "8080"),
  application_url: System.get_env("OF_WATCHDOG_URL", "http://localhost:#{System.get_env("OF_WATCHDOG_PORT", "8080")}"
