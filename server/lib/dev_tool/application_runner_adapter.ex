defmodule DevTool.ApplicationRunnerAdapter do
  @moduledoc """
  ApplicationRunnerAdapter for DevTool
  Defining functions to communicate with the application
  """
  @behaviour ApplicationRunner.AdapterBehavior

  alias ApplicationRunner.{SessionState}

  @impl true
  def get_manifest(_env) do
    url = Application.fetch_env!(:dev_tools, :application_url)

    headers = [{"Content-Type", "application/json"}]

    case Finch.build(:post, url, headers)
         |> Finch.request(AppHttp)
         |> response(:get_apps) do
      {:ok, %{"ui" => ui, "stats" => _stats}} -> {:ok, ui}
      error -> error
    end
  end

  @impl true
  def get_widget(widget_name, data, props) do
    url = Application.fetch_env!(:dev_tools, :application_url)

    headers = [{"Content-Type", "application/json"}]

    IO.inspect({widget_name, data})

    body =
      Map.put(
        %{data: data, props: props},
        :widget,
        widget_name
      )

    body = Jason.encode!(body)

    case Finch.build(:post, url, headers, body)
         |> Finch.request(AppHttp)
         |> response(:get_apps) do
      {:ok, %{"ui" => ui, "stats" => _stats}} -> {:ok, ui}
      error -> error
    end
  end

  @impl true
  def run_listener(_env, action, data, props, event) do
    url = Application.fetch_env!(:dev_tools, :application_url)

    headers = [{"Content-Type", "application/json"}]

    body =
      Map.put(
        %{data: data, props: props, event: event},
        :action,
        action
      )

    body = Jason.encode!(body)

    case Finch.build(:post, url, headers, body)
         |> Finch.request(AppHttp)
         |> response(:get_apps) do
      {:ok, %{"data" => data, "stats" => _stats}} -> {:ok, data}
      error -> error
    end
  end

  defp response({:ok, %Finch.Response{status: 200, body: body}}, :get_apps) do
    {:ok, Jason.decode!(body)}
  end

  defp response({:error, %Mint.TransportError{reason: _}}, _) do
    raise "Application could not be reached. Make sure that the application is started."
  end

  defp response({:ok, %Finch.Response{status: status_code, body: body}}, _)
       when status_code not in [200, 202] do
    raise "Application error (#{status_code}) #{body}"
  end

  @impl true
  def get_data(%SessionState{session_id: session_id} = _session_state) do
    create_ets_table_if_needed()

    case :ets.lookup(:data, session_id) do
      [{_, data}] -> {:ok, data}
      [] -> {:ok, %{}}
    end
  end

  @impl true
  def save_data(%SessionState{session_id: session_id} = _session_state, data) do
    create_ets_table_if_needed()
    :ets.insert(:data, {session_id, data})
    :ok
  end

  defp create_ets_table_if_needed() do
    if :ets.whereis(:data) == :undefined do
      :ets.new(:data, [:named_table, :public])
    end
  end

  @impl true
  def on_ui_changed(session_state, {atom, data}) do
    send(session_state.assigns.socket_pid, {:send, atom, data})
  end
end
