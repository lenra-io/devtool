import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dev_tools, DevTool.Endpoint,
  http: [port: 4002],
  server: false

# Mocking application_url in tests
config :dev_tools,
  of_watchdog: System.get_env("OF_WATCHDOG_BIN", "/usr/bin/fwatchdog"),
  upstream_url: System.get_env("OF_WATCHDOG_UPSTREAM_URL", "http://localhost:3000"),
  fprocess: System.get_env("OF_WATCHDOG_F_PROCESS", "npm start"),
  port: System.get_env("OF_WATCHDOG_PORT", "3333"),
  mode: System.get_env("OF_WATCHDOG_MODE", "http"),
  application_url: "http://localhost:#{System.get_env("OF_WATCHDOG_PORT", "3333")}"

config :dev_tools, DevTool.Repo,
  username: "postgres",
  password: "postgres",
  database: "lenra_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox,
  queue_target: 500

# Print only warnings and errors during test
config :logger, level: :warn
