import Config

config :dev_tools, DevTool.Endpoint,
  http: [port: 4001],
  server: true

config :dev_tools, DevTool.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DB"),
  hostname: System.get_env("POSTGRES_HOST")

config :application_runner, ApplicationRunner.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DB"),
  hostname: System.get_env("POSTGRES_HOST")

config :dev_tools,
  of_watchdog: System.get_env("OF_WATCHDOG_BIN"),
  port: System.get_env("OF_WATCHDOG_PORT", "8080"),
  application_url:
    System.get_env(
      "OF_WATCHDOG_URL",
      "http://localhost:#{System.get_env("OF_WATCHDOG_PORT", "8080")}"
    )

config :application_runner, :mongo,
  hostname: System.get_env("MONGO_HOSTNAME", "localhost"),
  port: System.get_env("MONGO_PORT", "27017"),
  username: System.get_env("MONGO_USERNAME"),
  password: System.get_env("MONGO_PASSWORD"),
  ssl: System.get_env("MONGO_SSL", "false"),
  auth_source: System.get_env("MONGO_AUTH_SOURCE")
