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
  def handle_info(:listen, _state) do
    get_line()
  end

  @impl true
  def handle_call(:stop, _from, state) do
    state
    |> Keyword.get(:pid)
    |> :exec.kill(15)
    |> case do
      :ok ->
        {:reply, :ok, Keyword.put(state, :pid, nil)}

      err ->
        {:reply, err, state}
    end
  end

  defp get_line do
    case IO.gets("") do
      # Reload watchdog
      "R\n" ->
        Logger.info("Reloading watchdog")
        DevTool.Watchdog.restart()

      _ ->
        nil
    end

    get_line()
  end
end
