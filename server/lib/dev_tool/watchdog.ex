defmodule DevTool.Watchdog do
  @moduledoc """
    This module handle the of-watchdog command.
    Start the watchdog with `DevTool.Watchdog.start/0``
    Stop the watchdog with `DevTool.Watchdog.stop/0`
    Restart the watchdog with `DevTool.Watchdog.restart/0`
  """

  use GenServer

  alias DevTool.Watchdog
  require Logger

  ##################
  ## Watchdog API ##
  ##################

  def start do
    GenServer.call(__MODULE__, :start)
  end

  def stop do
    GenServer.call(__MODULE__, :stop)
  end

  def restart do
    Watchdog.stop()
    Watchdog.start()
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ###########################
  ## Genserver private API ##
  ###########################
  @impl true
  def init(raw_opts) do
    Process.flag(:trap_exit, true)

    send(self(), :after_init)
    {:ok, [pid: nil, opts: check_opts(raw_opts)]}
  end

  @impl true
  def handle_call(:start, _from, state) do
    case do_start_watchdog(state) do
      {:ok, new_state} -> {:reply, :ok, new_state}
      {:error, reason, new_state} -> {:reply, {:error, reason}, new_state}
    end
  end

  @impl true
  def handle_call(:stop, _from, state) do
    do_stop_watchdog(state)
  end

  @impl true
  def handle_info(:after_init, state) do
    case do_start_watchdog(state) do
      {:ok, new_state} -> {:noreply, new_state}
      {:error, reason, new_state} -> {:stop, {:error, reason}, new_state}
    end
  end

  def handle_info({:stderr, _os_pid, msg}, state) do
    Logger.info(msg)
    {:noreply, state}
  end

  def handle_info({:stdout, _os_pid, msg}, state) do
    Logger.info(msg)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, state) do
    state
    |> Keyword.get(:pid)
    |> kill()
  end

  defp kill(pid) when is_nil(pid), do: {:error, :not_started}

  defp kill(pid) do
    pid
    |> :exec.kill(15)
    |> case do
      {:error, _} ->
        {:error, :not_started}

      :ok ->
        :ok
    end
  end

  defp check_opts(opts) do
    Keyword.get(opts, :of_watchdog) |> check_required(:of_watchdog)
    Keyword.get(opts, :upstream_url) |> check_required(:upstream_url)
    Keyword.get(opts, :fprocess) |> check_required(:fprocess)
    Keyword.get(opts, :port) |> check_required(:port)
    Keyword.get(opts, :mode) |> check_required(:mode)

    opts
  end

  defp check_required(str, atom) when is_nil(str), do: raise("#{inspect(atom)} is required")
  defp check_required(str, _atom), do: str

  defp do_start_watchdog(state) do
    Logger.info("Starting the application...")

    state
    |> Keyword.get(:pid)
    |> case do
      nil ->
        {:ok, pid, _os_pid} =
          state
          |> Keyword.get(:opts)
          |> start_process()

        # add "Press 'r' to reload the App."
        Logger.info("Application Started !")
        {:ok, Keyword.put(state, :pid, pid)}

      _ ->
        Logger.info("The application was already started")
        {:error, :already_started, state}
    end
  end

  defp do_stop_watchdog(state) do
    Logger.info("Stopping the application...")

    state
    |> Keyword.get(:pid)
    |> kill()
    |> case do
      :ok ->
        Logger.info("Application stopped.")
        {:reply, :ok, Keyword.put(state, :pid, nil)}

      err ->
        Logger.error("An error occured when stopping the application.")
        {:reply, err, state}
    end
  end

  defp start_process(opts) do
    :exec.run_link(
      Keyword.get(opts, :of_watchdog),
      [
        :stdout,
        :stderr,
        env: [
          {
            "upstream_url",
            Keyword.get(opts, :upstream_url)
          },
          {"fprocess", Keyword.get(opts, :fprocess)},
          {"port", Keyword.get(opts, :port)},
          {"mode", Keyword.get(opts, :mode)}
        ]
      ]
    )
  end
end