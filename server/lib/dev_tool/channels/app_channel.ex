defmodule DevTool.AppChannel do
  @moduledoc """
    `LenraWeb.AppChannel` handle the app channel to run app and listeners and push to the user the resulted UI or Patch
  """
  use Phoenix.Channel

  require Logger

  alias ApplicationRunner.{SessionManagers, SessionManager}

  @fake_user_id 1
  @fake_app_id 1
  @fake_build_number 1
  @fake_session_id 1

  def join("app", %{"app" => app_name}, socket) do
    Logger.info("Join channel for app : #{app_name}")
    {:ok, session_pid} = case SessionManagers.start_session(@fake_session_id, @fake_app_id, @fake_build_number, app_name, %{socket_pid: self()}) do
      {:ok, pid} ->
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        {:ok, pid}
      {:error, message} ->
        {:error, message}
    end

    SessionManager.init_data(session_pid)

    socket = assign(socket, session_pid: session_pid)

    # {:ok, %{"entrypoint" => entrypoint}} = EnvManager.get_manifest(env.env_id)

    # uuid = UUID.uuid1(:slug)

    # case SessionManager.get_widget(session, %WidgetContext{
    #   id: uuid,
    #   name: entrypoint
    # }) do
    #   {:ok, ui} ->
    #     send(self(), {:send_ui, ui})

    #   {:error, reason} ->
    #     Logger.error(inspect(reason))
    # end

    {:ok, socket}
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

  def handle_in("run", %{"code" => action_key, "event" => event}, socket) do
    handle_run(socket, action_key, event)
  end

  def handle_in("run", %{"code" => action_key}, socket) do
    handle_run(socket, action_key)
  end

  defp handle_run(socket, action_key, event \\ %{}) do
    %{session_pid: session_pid} = socket.assigns

    SessionManager.run_listener(session_pid, action_key, event)

    {:noreply, socket}
  end
end
