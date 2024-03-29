defmodule DevTool.FakeHydra.Endpoint do
  @moduledoc """
  The endpoint for the fake hydra.
  """
  use Phoenix.Endpoint, otp_app: :dev_tools

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_dev_tool_key",
    signing_salt: "ehlojLyn"
  ]
  plug(Plug.Static,
    at: "/",
    from: {:dev_tools, "priv/static_hydra"},
    gzip: false,
    only: ~w(assets css fonts images favicon.ico robots.txt)
  )

  plug(DevTool.HealthCheck)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  # plug(Plug.Static,
  #   at: "/",
  #   from: {:dev_tools, "priv/static"},
  #   gzip: false
  # )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(CORSPlug)
  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(Plug.Session, @session_options)
  plug(DevTool.FakeHydra.Router)
end
