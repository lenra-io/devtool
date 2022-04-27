defmodule DevTool.AppChannel do
  @moduledoc """
    `LenraWeb.AppChannel` handle the app channel to run app and listeners and push to the user the resulted UI or Patch
  """
  use Phoenix.Channel

  require Logger

  alias DevTool.{
    EnvironmentServices,
    ErrorHelpers,
    UserServices
  }

  alias ApplicationRunner.{
    SessionManager,
    SessionManagers
  }

  def join("app", %{"app" => app_name}, socket) do
    Logger.info("Join channel for app : #{app_name}")

    with env <- EnvironmentServices.get_first_env!(),
         user <- UserServices.get_first_user!() do
      session_assigns = %{
        user: user,
        environment: env,
        socket_pid: self()
      }

      env_assigns = %{
        environment: env
      }

      case SessionManagers.start_session(
             Ecto.UUID.generate(),
             env.id,
             session_assigns,
             env_assigns
           ) do
        {:ok, pid} ->
          socket = assign(socket, session_pid: pid)

          {:ok, socket}

        {:error, message} ->
          {:error, message}
      end
    end
  end

  def join("app", _any, _socket) do
    {:error, %{reason: "No App Name"}}
  end

  def handle_info({:send, :ui, ui}, socket) do
    Logger.debug("send ui #{inspect(ui)}")
    push(socket, "ui", ui)
    {:noreply, socket}
  end

  def handle_info({:send, :patches, patches}, socket) do
    Logger.debug("send patchUi  #{inspect(%{patch: patches})}")

    push(socket, "patchUi", %{"patch" => patches})
    {:noreply, socket}
  end

  def handle_info({:send, :error, {:error, reason}}, socket) when is_atom(reason) do
    Logger.error("Send error #{inspect(reason)}")

    push(socket, "error", %{"errors" => ErrorHelpers.translate_error(reason)})
    {:noreply, socket}
  end

  def handle_info({:send, :error, {:error, :invalid_ui, errors}}, socket) when is_list(errors) do
    formatted_errors =
      errors
      |> Enum.map(fn {message, path} -> %{code: 0, message: "#{message} at path #{path}"} end)

    push(socket, "error", %{"errors" => formatted_errors})
    {:noreply, socket}
  end

  def handle_info({:send, :error, reason}, socket) when is_atom(reason) do
    Logger.error("Send error atom #{inspect(reason)}")
    push(socket, "error", %{"errors" => ErrorHelpers.translate_error(reason)})
    {:noreply, socket}
  end

  def handle_info({:send, :error, malformatted_error}, socket) do
    Logger.error("Malformatted error #{inspect(malformatted_error)}")
    push(socket, "error", %{"errors" => ErrorHelpers.translate_error(:unknow_error)})
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

    SessionManager.send_client_event(session_pid, action_code, event)

    {:noreply, socket}
  end
end
