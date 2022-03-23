defmodule DevTool.Watchdog do
  use GenServer

  alias DevTool.{TerminalView, Watchdog}

  ##################
  ## Watchdog API ##
  ##################

  def start() do
    GenServer.call(__MODULE__, :start)
  end

  def stop() do
    GenServer.call(__MODULE__, :stop)
  end

  def restart() do
    Watchdog.stop()
    TerminalView.clear()
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

    {:ok, [pid: nil, opts: check_opts(raw_opts)]}
  end

  @impl true
  def handle_call(:start, _from, state) do
    TerminalView.send_log("Starting the application...")

    state
    |> Keyword.get(:pid)
    |> case do
      nil ->
        {:ok, pid, _os_pid} =
          state
          |> Keyword.get(:opts)
          |> start_process()

        TerminalView.send_log("Application Started !")
        {:reply, :ok, Keyword.put(state, :pid, pid)}

      _ ->
        TerminalView.send_log("The application was already started")
        {:reply, {:error, :already_started}, state}
    end
  end

  @impl true
  def handle_call(:stop, _from, state) do
    TerminalView.send_log("Stopping the application...")

    state
    |> Keyword.get(:pid)
    |> kill()
    |> case do
      :ok ->
        TerminalView.send_log("Application stopped.")
        {:reply, :ok, Keyword.put(state, :pid, nil)}

      err ->
        TerminalView.send_log("An error occured when stopping the application.")
        {:reply, err, state}
    end
  end

  @impl true
  def handle_info({:stderr, _os_pid, _msg}, state) do
    {:noreply, state}
  end

  def handle_info({:stdout, _os_pid, msg}, state) do
    TerminalView.send_log(msg)
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
