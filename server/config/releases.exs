import Config

config :dev_tools, DevTool.Endpoint,
  http: [port: 4000],
  server: true

config :dev_tools,
  of_watchdog: System.fetch_env!("OF_WATCHDOG_BIN"),
<<<<<<< HEAD
  port: System.get_env("OF_WATCHDOG_PORT", "3333"),
  application_url: "http://localhost:#{System.get_env("OF_WATCHDOG_PORT", "3333")}"

config :dev_tools, DevTool.Repo,
  username: System.fetch_env!("POSTGRES_USER"),
  password: System.fetch_env!("POSTGRES_PASSWORD"),
  database: System.fetch_env!("POSTGRES_DB"),
  hostname: System.fetch_env!("POSTGRES_HOST")

# Do not print debug messages in production
config :logger, level: :info
=======
  port: System.get_env("OF_WATCHDOG_PORT", "8080"),
  application_url: "http://localhost:#{System.get_env("OF_WATCHDOG_PORT", "8080")}"
>>>>>>> beta
