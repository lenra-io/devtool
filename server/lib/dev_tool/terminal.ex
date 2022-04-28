defmodule DevTool.Terminal do
  @moduledoc """
  Devtool Terminal input handler
  """

  use GenServer

  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(opts \\ []) do
    send(self(), :listen)

    {:ok, opts}
  end

  @impl true
  def handle_info(:listen, state) do
    spawn_link(DevTool.Terminal, :listen, [])

    {:noreply, state}
  end

  def listen do
    case IO.gets("") do
      "R\n" ->
        Logger.info("Reloading watchdog")
        DevTool.Watchdog.restart()

      _ ->
        nil
    end

    listen()
  end
end
