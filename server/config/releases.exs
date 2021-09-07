import Config

config :dev_tool, DevTool.Endpoint,
  http: [port: 4000],
  server: true

config :dev_tool,
  application_url: System.get_env("APPLICATION_URL", "http://application:3000/")

# Do not print debug messages in production
config :logger, level: :info
