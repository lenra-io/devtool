defmodule DevTool.IndexController do
  use DevTool, :controller

  require Logger

  def index(conn, params) do
    IO.inspect("INDEX CONTROLLER")
    IO.inspect(conn)
    IO.inspect(params)

    Logger.info("INDEX CONTROLLER")
    Logger.info(conn)
    Logger.info(params)

    conn
    |> Plug.Conn.send_file(200, Path.join(:code.priv_dir(:dev_tools), "static/index.html"))
  end
end
