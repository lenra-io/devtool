defmodule DevTool.FakeHydra.Router do
  @moduledoc """
  The router for the fake hydra.
  """
  use DevTool, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    # plug :fetch_live_flash
    plug :put_root_layout, {DevTool.LayoutView, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", DevTool.FakeHydra do
    pipe_through [:browser]
    get("/oauth2/auth", OAuth2Controller, :auth)
    get("/choose/user", OAuth2Controller, :user)
    post("/oauth2/token", OAuth2Controller, :token)
    get("/oauth2/revoke", OAuth2Controller, :revoke)
  end
end
