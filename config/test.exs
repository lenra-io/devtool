import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dev_tool, DevTool.Endpoint,
  http: [port: 4002],
  server: false

# Mocking application_url in tests
config :dev_tool,
  application_url: "http://localhost:6789"

# Print only warnings and errors during test
config :logger, level: :warn
