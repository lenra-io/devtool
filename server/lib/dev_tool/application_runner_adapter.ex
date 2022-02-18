defmodule DevTool.ApplicationRunnerAdapter do
  @moduledoc """
  ApplicationRunnerAdapter for DevTool
  Defining functions to communicate with the application
  """
  @behaviour ApplicationRunner.AdapterBehavior

  alias ApplicationRunner.SessionState
  require Logger

  def application_url, do: Application.fetch_env!(:dev_tools, :application_url)

  @impl true
  def get_manifest(_env) do
    headers = [{"Content-Type", "application/json"}]

    case Finch.build(:post, application_url(), headers)
         |> Finch.request(AppHttp)
         |> response(:decode) do
      {:ok, %{"manifest" => manifest}} ->
        {:ok, manifest}

      other ->
        {:error,
         "Application error (The format of the manifest should be {:ok, %{\"manifest\" => manifest}} but was #{inspect(other)})"}
    end
  end

  @impl true
  def get_widget(_env_state, widget_name, data, props) do
    headers = [{"Content-Type", "application/json"}]

    body = Jason.encode!(%{data: data, props: props, widget: widget_name})

    case Finch.build(:post, application_url(), headers, body)
         |> Finch.request(AppHttp)
         |> response(:decode) do
      {:ok, %{"widget" => widget}} ->
        {:ok, widget}

      error ->
        error
    end
  end

  @impl true
  def run_listener(_env, action, data, props, event) do
    headers = [{"Content-Type", "application/json"}]

    body = Jason.encode!(%{data: data, props: props, event: event, action: action})

    case Finch.build(:post, application_url(), headers, body)
         |> Finch.request(AppHttp)
         |> response(:decode) do
      {:ok, %{"data" => data}} ->
        {:ok, data}

      error ->
        error
    end
  end

  defp response({:ok, %Finch.Response{status: 200, body: body}}, :decode) do
    {:ok, Jason.decode!(body)}
  end

  defp response({:error, %Mint.TransportError{reason: reason}}, _action) do
    err = "Application could not be reached #{reason}."
    Logger.error(err)
    {:error, err}
  end

  defp response({:ok, %Finch.Response{status: status_code, body: body}}, _)
       when status_code not in [200, 202] do
    err = "Application error (#{status_code}) #{body}"
    Logger.error(err)
    {:error, err}
  end

  @impl true
  def get_data(%SessionState{session_id: session_id} = _session_state) do
    create_ets_table_if_needed()

    case :ets.lookup(:data, session_id) do
      [{_, data}] ->
        {:ok, data}

      [] ->
        {:ok, %{}}
    end
  end

  @impl true
  def save_data(%SessionState{session_id: session_id} = _session_state, data) do
    create_ets_table_if_needed()

    :ets.insert(:data, {session_id, data})
    :ok
  end

  defp create_ets_table_if_needed do
    if :ets.whereis(:data) == :undefined do
      :ets.new(:data, [:named_table, :public])
    end
  end

  @impl true
  def on_ui_changed(%SessionState{} = session_state, {atom, data}) do
    send(session_state.assigns.socket_pid, {:send, atom, data})
  end
end
