defmodule DevTool.Terminal do
  @moduledoc """
  Devtool Terminal input handler
  """

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(opts \\ []) do
    send(self(), :listen)

    {:ok, opts}
  end

  def handle_info(:listen, state) do
    get_line()

    {:noreply, state}
  end

  defp get_line() do
    case IO.gets("") do
      # Reload watchdog
      "R\n" ->
        IO.puts("Reloading watchdog")
        GenServer.call(DevTool.Watchdog, :stop)

      _ ->
        nil
    end

    get_line()
  end
end
