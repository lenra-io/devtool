defmodule DevTool.IndexController do
  use DevTool, :controller

  require Logger

  def index(conn, _params) do
    conn
    |> Plug.Conn.send_file(200, Path.join(:code.priv_dir(:dev_tools), "static/index.html"))
  end
end
