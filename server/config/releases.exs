import Config

config :dev_tools, DevTool.Endpoint,
  http: [port: 4000],
  server: true

config :dev_tools,
  application_url: System.get_env("APPLICATION_URL", "http://localhost:3000/")

# Do not print debug messages in production
config :logger, level: :info
