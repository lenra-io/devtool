defmodule DevTool.LenraTokenController do
  @moduledoc """
    Controller which generates fake token for Lenra client
  """
  use DevTool, :controller

  alias DevTool.FakeHydra.Oauth2Helper

  def generate(conn, _opts) do
    conn
    |> send_resp(200, Oauth2Helper.generate_fake_token("app:websocket"))
    |> halt()
  end
end
