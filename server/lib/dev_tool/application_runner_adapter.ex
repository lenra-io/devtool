defmodule DevTool.ApplicationRunnerAdapter do
  @moduledoc """
  ApplicationRunnerAdapter for DevTool
  Defining functions to communicate with the application
  """
  @behaviour ApplicationRunner.AdapterBehavior

  alias ApplicationRunner.{
    EnvState,
    SessionState
  }

  alias DevTool.{
    DataServices,
    Environment,
    UserDataServices
  }

  require Logger

  def application_url, do: Application.fetch_env!(:dev_tools, :application_url)

  @impl true
  def get_manifest(_env) do
    headers = [{"Content-Type", "application/json"}]

    case Finch.build(:post, application_url(), headers)
         |> Finch.request(AppHttp)
         |> response(:manifest) do
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
         |> response(:widget) do
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

    # generate token
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

    # generate token
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
    headers = [
      {"Content-Type", "application/json"}
    ]

    body =
      Jason.encode!(%{
        action: action,
        props: props,
        event: event,
        api: %{url: "http://localhost:4000", token: token}
      })

    Finch.build(:post, application_url(), headers, body)
    |> Finch.request(AppHttp, receive_timeout: 1000)
    |> response(:listener)
  end

  defp response({:ok, %Finch.Response{status: 200, body: body}}, key)
       when key in [:manifest, :widget] do
    {:ok, Jason.decode!(body)}
  end

  defp response({:ok, %Finch.Response{status: 200}}, :listener) do
    :ok
  end

  defp response({:error, %Mint.TransportError{reason: reason}}, _key) do
    err = "Application could not be reached #{reason}."
    Logger.error(err)
    {:error, err}
  end

  defp response({:ok, %Finch.Response{status: 404, body: body}}, :listener) do
    err = "Application error (404) #{inspect(body)}"
    Logger.error(err)
    :error404
  end

  defp response({:ok, %Finch.Response{status: status_code, body: body}}, _key)
       when status_code not in [200, 202] do
    err = "Application error (#{status_code}) #{body}"
    Logger.error(err)
    {:error, err}
  end

  @impl true
  def exec_query(%SessionState{assigns: %{environment: env, user: user}}, query) do
    DataServices.exec_query(query, env.id, user.id)
  end

  @impl true
  def first_time_user?(%SessionState{assigns: %{user: user, environment: env}}) do
    not UserDataServices.has_user_data?(env.id, user.id)
  end

  @impl true
  def create_user_data(%SessionState{assigns: %{user: user, environment: env}}) do
    UserDataServices.create_user_data(env.id, user.id)
  end

  @impl true
  def on_ui_changed(
        %SessionState{
          assigns: %{
            socket_pid: socket_pid
          }
        },
        {atom, ui_or_patches}
      ) do
    send(socket_pid, {:send, atom, ui_or_patches})
  end

  def on_ui_changed(session_state, message) do
    raise "Error, not maching on_ui_changed/2 #{inspect(session_state)}, #{inspect(message)}"
  end
end
