defmodule DevTool.Client.IndexController do
  use DevTool, :controller

  def index(conn, _params) do
    conn
    |> Plug.Conn.send_file(200, Path.join(:code.priv_dir(:dev_tools), "static/index.html"))
  end
end
