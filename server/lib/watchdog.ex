defmodule DevTool.Watchdog do
  use GenServer

  # @of_watchdog "/Users/louis/Documents/lenra/dev-tools/server/node12/of-watchdog"
  # @upstream_url_erl 'http://127.0.0.1:3000'
  # @fprocess_erl 'node node12/index.js'
  # @port_erl '3333'
  # @mode_erl 'http'

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
    DevTool.Watchdog.stop()
    DevTool.Watchdog.start()
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

    opts = format_opts(raw_opts)
    {:ok, [port: nil, opts: opts]}
  end

  @impl true
  def handle_call(:start, _from, state) do
    state
    |> Keyword.get(:port)
    |> Port.info()
    |> case do
      nil ->
        port =
          state
          |> Keyword.get(:opts)
          |> start_port()

        {:reply, :ok, Keyword.put(state, :port, port)}

      _ ->
        {:reply, {:error, :already_started}, state}
    end
  end

  @impl true
  def handle_call(:stop, _from, state) do
    state
    |> Keyword.get(:port)
    |> stop_and_kill()
    |> case do
      :ok ->
        {:reply, :ok, Keyword.put(state, :port, nil)}

      err ->
        {:reply, err, state}
    end
  end

  @impl true
  def handle_info({_port, {:data, _log}}, state) do
    # IO.inspect(log)
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, state) do
    state
    |> Keyword.get(:port)
    |> stop_and_kill()
  end

  defp stop_and_kill(port) do
    port
    |> Port.info(:os_pid)
    |> case do
      nil ->
        {:error, :not_started}

      {:os_pid, os_pid} ->
        Port.close(port)

        case System.cmd("kill", ["-15", "#{os_pid}"]) do
          {_, 0} -> :ok
          {_, _} -> {:error, :no_watchdog_process}
        end
    end
  end

  defp format_opts(opts) do
    of_watchdog = Keyword.get(opts, :of_watchdog)
    if not is_bitstring(of_watchdog), do: raise("#{inspect(of_watchdog)} should be a string")

    upstream_url_erl = Keyword.get(opts, :upstream_url) |> to_erl(:upstream_url)
    fprocess_erl = Keyword.get(opts, :fprocess) |> to_erl(:fprocess)
    port_erl = Keyword.get(opts, :port) |> to_erl(:port)
    mode_erl = Keyword.get(opts, :mode) |> to_erl(:mode)

    %{
      of_watchdog: of_watchdog,
      upstream_url_erl: upstream_url_erl,
      fprocess_erl: fprocess_erl,
      port_erl: port_erl,
      mode_erl: mode_erl
    }
  end

  defp to_erl(str, _atom) when is_bitstring(str), do: Kernel.to_charlist(str)
  defp to_erl(str, atom) when is_nil(str), do: raise("#{inspect(atom)} is required")
  defp to_erl(_str, atom), do: raise("opts #{inspect(atom)} should be a string")

  defp start_port(opts) do
    Port.open(
      {:spawn_executable, opts.of_watchdog},
      [
        :hide,
        :nouse_stdio,
        env: [
          {
            'upstream_url',
            opts.upstream_url_erl
          },
          {'fprocess', opts.fprocess_erl},
          {'port', opts.port_erl},
          {'mode', opts.mode_erl}
        ]
      ]
    )
  end
end
