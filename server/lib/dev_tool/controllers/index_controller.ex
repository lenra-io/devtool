defmodule DevTool.IndexController do
  use DevTool, :controller

  def index(conn, _params) do
    conn
    |> Plug.Conn.send_file(200, Path.join(:code.priv_dir(:dev_tool), "static/index.html"))
  end
end
