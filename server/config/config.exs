# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :dev_tools,
  ecto_repos: [DevTool.Repo],
  application_url: System.get_env("APPLICATION_URL", "http://localhost:3000/")

config :dev_tools, DevTool.Repo,
  migration_timestamps: [type: :utc_datetime],
  pool_size: 10

# Configures the endpoint
config :dev_tools, DevTool.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "q0rPsy3L8JOAYVx0hglOsYuKwo/uVWvdYVQTkus5a/wkJnka3F1k7xyLJEK7r2TH",
  render_errors: [view: DevTool.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: DevTool.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_component_schema,
       :remote_schema_resolver,
       {ApplicationRunner.JsonSchemata, :read_schema}

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :application_runner,
  adapter: DevTool.ApplicationRunnerAdapter,
  lenra_environment_table: "environments",
  lenra_user_table: "users",
  repo: DevTool.Repo,
  url: "http://localhost:4000",
  faas_url: "http://localhost:3000",
  faas_auth: ""

config :application_runner, ApplicationRunner.Guardian.AppGuardian,
  issuer: "lenra",
  secret_key: "5oIBVh2Hauo3LT4knNFu29lX9DYu74SWZfjZzYn+gfr0aryxuYIdpjm8xd0qGGqK"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
