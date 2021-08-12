defmodule DevTool.AppChannel do
  @moduledoc """
    `LenraWeb.AppChannel` handle the app channel to run app and listeners and push to the user the resulted UI or Patch
  """
  use Phoenix.Channel

  require Logger

  alias ApplicationRunner.{Action, ActionBuilder}

  @fake_user_id 1
  @fake_build_number 1

  def join("app", %{"app" => app_name}, socket) do
    Logger.info("Join channel for app : #{app_name}")

    socket = assign(socket, app_name: app_name, build_number: @fake_build_number)

    case ActionBuilder.first_run(%Action{
           user_id: @fake_user_id,
           app_name: app_name,
           build_number: @fake_build_number
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
    %{app_name: app_name, build_number: build_number} = socket.assigns

    case ApplicationRunner.ActionBuilder.listener_run(%Action{
           user_id: @fake_user_id,
           app_name: app_name,
           build_number: build_number,
           action_key: action_key,
           event: event
         }) do
      {:ok, patch} ->
        push(socket, "patchUi", %{patch: patch})

      {:error, reason} ->
        Logger.error(reason)
    end

    {:noreply, socket}
  end
end
