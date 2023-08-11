defmodule DevTool.LenraTokenController do
  @moduledoc """
    Controller who generates fake token for Lenra client
  """
  use DevTool, :controller

  alias DevTool.FakeHydra.OAuth2Helper

  def generate(conn, _opts) do
    conn
    |> send_resp(200, OAuth2Helper.generate_fake_token("app:websocket"))
    |> halt()
  end
end
