defmodule DevTool.HealthCheck do
  use DevTool, :controller

  def call(%Plug.Conn{request_path: "/healthcheck"} = conn, _opts) do
    conn
    |> send_resp(200, "")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
