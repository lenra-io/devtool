defmodule DevTool.FallbackController do
  use DevTool, :controller

  def call(%Plug.Conn{} = conn, {:error, reason}) do
    conn
    |> assign_error(reason)
    |> reply
  end

  def call(%Plug.Conn{} = conn, {:error, _error, reason, _reason}) do
    conn
    |> assign_error(reason)
    |> reply
  end
end
