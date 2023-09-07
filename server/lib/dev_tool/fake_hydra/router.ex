defmodule DevTool.FakeHydra.Router do
  @moduledoc """
  The router for the fake hydra.
  """
  use DevTool, :router

  scope "/", DevTool.FakeHydra do
    get("/oauth2/auth", OAuth2Controller, :auth)
    post("/oauth2/token", OAuth2Controller, :token)
    get("/oauth2/revoke", OAuth2Controller, :revoke)
  end
end
