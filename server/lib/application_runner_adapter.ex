defmodule DevTool.ApplicationRunnerAdapter do
  @moduledoc """
  ApplicationRunnerAdapter for DevTool
  Defining functions to communicate with the application
  """
  alias ApplicationRunner.{Storage, EnvState, WidgetContext, ListenerContext}

  @spec get_manifest(EnvState.t()) :: {:ok, map} | {:error, map}
  def get_manifest(_env) do
    url = Application.fetch_env!(:dev_tools, :application_url)

    headers = [{"Content-Type", "application/json"}]

   case Finch.build(:post, url, headers)
    |> Finch.request(AppHttp)
    |> response(:get_apps) do
      {:ok, %{ "ui" => ui, "stats" => _stats }} -> {:ok, ui}
      error -> error
    end
  end

  @spec get_widget(EnvState.t(), WidgetContext.t(), map()) :: {:ok, map} | {:error, map}
  def get_widget(_env, widget, data) do
    url = Application.fetch_env!(:dev_tools, :application_url)

    headers = [{"Content-Type", "application/json"}]

    body =
      Map.put(
        %{data: data, props: widget.props},
        :widget,
        widget.widget_name
      )

    body = Jason.encode!(body)

    case Finch.build(:post, url, headers, body)
    |> Finch.request(AppHttp)
    |> response(:get_apps) do
      {:ok, %{ "ui" => ui, "stats" => _stats }} -> {:ok, ui}
      error -> error
    end
  end

  @spec run_listener(EnvState.t(), ListenerContext.t(), map()) :: {:ok, map()} | {:error, map}
  def run_listener(_env, listener, data) do
    url = Application.fetch_env!(:dev_tools, :application_url)

    headers = [{"Content-Type", "application/json"}]

    body =
      Map.put(
        %{data: data, props: listener.props, event: listener.event},
        :listener,
        listener.listener_key
      )

    body = Jason.encode!(body)

    Finch.build(:post, url, headers, body)
    |> Finch.request(AppHttp)
    |> response(:get_apps)
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

  def get_data(action) do
    case Storage.get(:datastore, :data) do
      nil -> {:ok, action}
      data -> {:ok, %{action | old_data: data}}
    end
  end

  def save_data(_action, data) do
    Storage.insert(:datastore, :data, data)
  end
end
