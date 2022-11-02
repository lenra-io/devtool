defmodule DevTool.HealthCheck do
  @moduledoc """
    Controller who manages health check requests
  """
  use DevTool, :controller

  def call(%Plug.Conn{request_path: "/health", method: "GET"} = conn, _opts) do
    conn
    |> send_resp(200, "")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
