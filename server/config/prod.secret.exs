# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

config :dev_tools, DevTool.Endpoint,
  http: [
    port: String.to_integer(System.get_env("API_PORT") || "4001"),
    transport_options: [socket_opts: [:inet6]]
  ]

config :dev_tools, DevTool.Client.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ]

config :dev_tools, DevTool.FakeHydra.Endpoint,
  http: [
    port: String.to_integer(System.get_env("OAUTH_PORT") || "4444"),
    transport_options: [socket_opts: [:inet6]]
  ]

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :dev_tool, DevTool.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
