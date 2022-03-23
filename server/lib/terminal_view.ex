defmodule DevTool.TerminalView do
  @behaviour Ratatouille.App

  import Ratatouille.View
  import Ratatouille.Constants, only: [key: 1]

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)

  @default_model %{
    logs: [],
    cursor: 0,
    cursor_hooked?: true,
    nb_lines: 0
  }

  def init(context) do
    Map.merge(
      @default_model,
      %{
        width: context.window.width,
        height: context.window.height
      }
    )
  end

  @spec send_log(String.t()) :: :ok
  def send_log(log) do
    send_event(:log, log)
  end

  @spec clear :: :ok
  def clear() do
    send_event(:clear)
  end

  defp send_event(key, mod \\ nil) do
    pid = GenServer.whereis(Ratatouille.EventManager)
    event = %ExTermbox.Event{type: :custom, mod: mod, key: key}
    send(pid, {:event, event})
    :ok
  end

  def update(model, {:event, %{ch: ?r}}) do
    DevTool.Watchdog.restart()
    model
  end

  def update(model, {:event, %{type: :custom, key: :log, mod: log}}) do
    add_log(model, log)
  end

  def update(model, {:event, %{type: :custom, key: :clear}}) do
    Map.merge(model, @default_model)
  end

  def update(model, {:event, %{key: @arrow_up}}) do
    if model.cursor > 0 do
      Map.merge(model, %{cursor: model.cursor - 1, cursor_hooked?: false})
    else
      model
    end
  end

  def update(model, {:event, %{key: @arrow_down}}) do
    if full_page_log?(model) do
      model =
        Map.merge(model, %{
          cursor: min(model.cursor + 1, model.nb_lines - model.height)
        })

      if cursor_bottom_page?(model) do
        Map.merge(model, %{
          cursor_hooked?: true
        })
      else
        model
      end
    else
      model
    end
  end

  def update(model, {:resize, %{h: height, w: width}}) do
    cond do
      height != model.height ->
        Map.merge(model, %{height: height})

      width != model.width ->
        new_nb_lines =
          Enum.reduce(model.logs, 0, fn log, acc ->
            acc + div(String.length(log), model.width) + 1
          end)

        Map.merge(model, %{width: width, nb_lines: new_nb_lines})
    end
  end

  def update(model, _msg) do
    model
  end

  defp add_log(model, logs) do
    # process log to be compatible with line width count
    processed_logs =
      logs
      |> String.trim_trailing("\n")
      |> String.split("\n")

    Enum.reduce(processed_logs, model, fn log, acc ->
      do_add_logs(acc, log)
    end)
  end

  defp do_add_logs(model, processed_log) do
    model =
      Map.merge(model, %{
        logs: model.logs ++ [processed_log],
        nb_lines: model.nb_lines + div(String.length(processed_log), model.width) + 1
      })

    if model.cursor_hooked? and full_page_log?(model) do
      Map.merge(model, %{cursor: model.nb_lines - model.height})
    else
      model
    end
  end

  def cursor_bottom_page?(model) do
    model.nb_lines - model.height == model.cursor
  end

  def full_page_log?(model) do
    model.nb_lines >= model.height
  end

  def render(model) do
    view do
      viewport(offset_y: model.cursor) do
        Enum.map(model.logs, fn log -> label(content: log, wrap: true) end)
      end
    end
  end
end
