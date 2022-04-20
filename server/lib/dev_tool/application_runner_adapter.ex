defmodule DevTool.ApplicationRunnerAdapter do
  @moduledoc """
  ApplicationRunnerAdapter for DevTool
  Defining functions to communicate with the application
  """
  @behaviour ApplicationRunner.AdapterBehavior

  alias ApplicationRunner.{EnvState, SessionState}
  alias DevTool.Environment
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
  def run_listener(
        %EnvState{
          env_id: _env_id,
          assigns: %{
            environment: environment
          }
        },
        action,
        props,
        event
      ) do
    Logger.info("Run env listener for action #{action}")

    # TODO generate token
    token = ""

    run_listener(
      environment,
      action,
      props,
      event,
      token
    )
  end

  @impl true
  def run_listener(
        %SessionState{
          session_id: _session_id,
          assigns: %{
            environment: environment
          }
        },
        action,
        props,
        event
      ) do
    Logger.info("Run session listener for action #{action}")

    # TODO generate token
    token = ""

    run_listener(
      environment,
      action,
      props,
      event,
      token
    )
  end

  defp run_listener(
         %Environment{} = _environment,
         action,
         props,
         event,
         token
       ) do
    [host: host] = Application.get_env(:lenra_web, LenraWeb.Endpoint)[:url]
    [port: port] = Application.get_env(:lenra_web, LenraWeb.Endpoint)[:http]

    headers = [
      {"Content-Type", "application/json"}
    ]

    body =
      Jason.encode!(%{
        action: action,
        props: props,
        event: event,
        api_options: %{host: host, port: port, token: token}
      })

    Finch.build(:post, application_url(), headers, body)
    |> Finch.request(FaasHttp, receive_timeout: 1000)
    |> response(:decode)
    |> case do
      {:ok, _res} ->
        :ok

      err ->
        err
    end
  end

  @impl true
  def exec_query(_session_state, _query) do
    # WAIT FOR SERVICE TO IMLEMENT
    %{}
  end

  @impl true
  def ensure_user_data_created(_session_state) do
    # WAIT FOR SERVICE TO IMLEMENT
    :ok
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
  def on_ui_changed(%SessionState{} = session_state, {atom, data}) do
    send(session_state.assigns.socket_pid, {:send, atom, data})
  end
end
