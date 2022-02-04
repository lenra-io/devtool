defmodule DevTool.AppChannel do
  @moduledoc """
    `LenraWeb.AppChannel` handle the app channel to run app and listeners and push to the user the resulted UI or Patch
  """
  use Phoenix.Channel

  require Logger

  alias ApplicationRunner.{
    SessionManager,
    SessionManagers
  }

  @fake_env_id 1

  def join("app", %{"app" => app_name}, socket) do
    Logger.info("Join channel for app : #{app_name}")

    case SessionManagers.start_session(
           System.unique_integer(),
           @fake_env_id,
           %{socket_pid: self()},
           %{}
         ) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, message} ->
        {:error, message}
    end
    |> case do
      {:ok, pid} ->
        socket = assign(socket, session_pid: pid)
        SessionManager.init_data(pid)

        {:ok, socket}

      {:error, message} ->
        {:error, %{reason: message}}
    end
  end

  def join("app", _any, _socket) do
    {:error, %{reason: "No App Name"}}
  end

  def handle_info({:send, :ui, ui}, socket) do
    push(socket, "ui", ui)
    {:noreply, socket}
  end

  def handle_info({:send, :patches, patches}, socket) do
    push(socket, "patchUi", %{"patch" => patches})
    {:noreply, socket}
  end

  def handle_in("run", %{"code" => action_code, "event" => event}, socket) do
    handle_run(socket, action_code, event)
  end

  def handle_in("run", %{"code" => action_code}, socket) do
    handle_run(socket, action_code)
  end

  defp handle_run(socket, action_code, event \\ %{}) do
    %{session_pid: session_pid} = socket.assigns

    SessionManager.run_listener(session_pid, action_code, event)

    {:noreply, socket}
  end
end
