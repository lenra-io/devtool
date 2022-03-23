defmodule DevTool.TerminalController do
  use GenServer

  alias ExTermbox.Bindings, as: Termbox
  alias ExTermbox.{Cell, EventManager, Event, Position}

  def start_link(opts) do
    Process.flag(:trap_exit, true)

    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def println(msg) do
    GenServer.cast(__MODULE__, {:println, msg})
  end

  ###########################
  ## Genserver private API ##
  ###########################
  @impl true
  def init(raw_opts) do
    :ok = Termbox.init()

    EventManager.subscribe(self())
    {:ok, height} = Termbox.height()
    {:ok, width} = Termbox.width()

    {:ok,
     [
       opts: check_opts(raw_opts),
       buffer: [],
       cursor_line: -1,
       height: height,
       width: width
     ]}
  end

  @impl true
  def handle_info({:event, %Event{} = event}, state) do
    case event do
      %Event{ch: ?q} ->
        stop(state)

      # ctrl + C
      %Event{key: 3, type: 1} ->
        stop(state)

      %Event{ch: ?r} ->
        __MODULE__.println(
          "Reload This line is way to looooooong to be draw in a single terminal width. This should be draw in multiple lines. Lorem impsus is just for test purpose to be long enougth"
        )

        {:noreply, state}

      %Event{} ->
        IO.inspect(event)
        nil
        {:noreply, state}
    end
  end

  @impl true
  def handle_cast({:println, msg}, state) do
    bin_msg =
      msg
      |> String.split("\n")
      |> Enum.map(&Kernel.to_charlist/1)

    buffer = Keyword.get(state, :buffer) ++ bin_msg

    {:noreply, Keyword.put(state, :buffer, buffer), {:continue, :redraw}}
  end

  @impl true
  def handle_continue(:redraw, state) do
    Termbox.clear()
    buffer = Keyword.get(state, :buffer)
    # cursor_line = Keyword.get(state, :cursor_line)
    # width = Keyword.get(state, :width)
    # height = Keyword.get(state, :height)

    # print(buffer, 0, 0, cursor_line, width, height)
    print_buffer(state, buffer)
    Termbox.present()
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, _state) do
    :ok = Termbox.shutdown()
  end

  defp stop(state) do
    :ok = Termbox.shutdown()
    :init.stop()
    {:noreply, state}
  end

  defp print_buffer(state, buffer), do: print_buffer(state, buffer, 0)
  defp print_buffer(_state, [], _y), do: :ok

  defp print_buffer(state, [line | buffer], y) do
    new_y = print_line(state, line, y)
    print_buffer(state, buffer, new_y)
  end

  defp print_line(state, line, y), do: print_line(state, line, 0, y)
  defp print_line(_state, [], _x, y), do: y + 1

  defp print_line(state, [ch | line], x, y) do
    height = Keyword.get(state, :height)

    cond do
      y >= height ->
        y

      true ->
        {new_x, new_y} = print_char(state, ch, x, y)
        print_line(state, line, new_x, new_y)
    end
  end

  defp print_char(state, ch, x, y) do
    width = Keyword.get(state, :width)
    height = Keyword.get(state, :height)

    cond do
      y >= height ->
        {x, y}

      x >= width ->
        print_char(state, ch, 0, y + 1)

      true ->
        :ok = Termbox.put_cell(%Cell{position: %Position{x: x, y: y}, ch: ch})
        {x + 1, y}
    end
  end

  # defp print([?\n | tail], _x, y, cursor_line, width, height) do
  #   print(tail, 0, y + 1, cursor_line, width, height)
  # end

  # defp print([], _x, _y, _cursor_line, _width, _height) do
  #   :ok
  # end

  # defp print([ch | tail], x, y, cursor_line, width, height) do
  #   if x >= width do
  #     :ok
  #   else if y >

  #   :ok = Termbox.put_cell(%Cell{position: %Position{x: x, y: y}, ch: ch})
  #   print(tail, x + 1, y, cursor_line, width, height)
  # end

  defp check_opts(opts) do
    opts
  end
end
