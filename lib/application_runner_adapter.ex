defmodule DevTool.ApplicationRunnerAdapter do
  @moduledoc """
  ApplicationRunnerAdapter for DevTool
  Defining functions to communicate with the application
  """

  @behaviour ApplicationRunner.AdapterBehavior

  alias ApplicationRunner.Storage

  @impl true
  def run_action(action) do
    url = Application.fetch_env!(:dev_tool, :application_url)

    headers = [{"Content-Type", "application/json"}]

    body =
      Map.put(
        %{data: action.old_data, props: action.props, event: action.event},
        :action,
        action.action_name
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

  @impl true
  def get_data(action) do
    case Storage.get(:datastore, :data) do
      nil -> {:ok, action}
      data -> {:ok, %{action | old_data: data}}
    end
  end

  @impl true
  def save_data(_action, data) do
    Storage.insert(:datastore, :data, data)
  end
end
