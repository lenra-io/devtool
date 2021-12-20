defmodule DevTool.AppChannel do
  @moduledoc """
    `LenraWeb.AppChannel` handle the app channel to run app and listeners and push to the user the resulted UI or Patch
  """
  use Phoenix.Channel

  require Logger

  alias ApplicationRunner.{SessionManagers, EnvManagers, EnvManager, SessionManager, SessionState, EnvState, WidgetContext, ListenerContext, ActionBuilder}

  @fake_user_id 1
  @fake_app_id 1
  @fake_build_number 1
  @fake_session_id 1

  def join("app", %{"app" => app_name}, socket) do
    Logger.info("Join channel for app : #{app_name}")

    env = %EnvState {
      env_id: @fake_app_id,
      app_name: app_name,
      build_number: @fake_build_number
    }

    socket = assign(socket, session_id: @fake_session_id, app_id: env.env_id, app_name: env.app_name, build_number: env.build_number)

    {:ok, _session_pid} = SessionManagers.start_session(@fake_session_id, env.env_id, env.build_number, env.app_name)
    {:ok, _app_pid} = EnvManagers.fetch_env_manager_pid(env.env_id)

    {:ok, %{"entrypoint" => entrypoint}} = EnvManager.get_manifest(env.env_id)

    uuid = UUID.uuid1(:slug)

    case SessionManager.get_widget(%SessionState{
      session_id: @fake_session_id,
      env_id: @fake_app_id,
    }, %WidgetContext{
      id: uuid,
      name: entrypoint
    }) do
      {:ok, ui} ->
        send(self(), {:send_ui, ui})

      {:error, reason} ->
        Logger.error(inspect(reason))
    end

    {:ok, socket}
  end

  def join("app", _any, _socket) do
    {:error, %{reason: "No App Name"}}
  end

  def handle_info({:send_ui, ui}, socket) do
    push(socket, "ui", ui)
    {:noreply, socket}
  end

  def handle_in("run", %{"code" => action_key, "event" => event}, socket) do
    handle_run(socket, action_key, event)
  end

  def handle_in("run", %{"code" => action_key}, socket) do
    handle_run(socket, action_key)
  end

  defp handle_run(socket, action_key, event \\ %{}) do
    %{session_id: session_id, app_id: app_id, app_name: app_name, build_number: build_number} = socket.assigns

    ApplicationRunner.ActionBuilder.run_listener(
      %SessionState{
        session_id: session_id,
        env_id: app_id,
      },
      %ListenerContext{
        listener_key: action_key,
        event: event
      },
      %{}
    )

    {:noreply, socket}
  end
end
