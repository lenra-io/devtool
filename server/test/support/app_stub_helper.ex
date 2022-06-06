defmodule DevTool.AppStub do
  @moduledoc """
    Helper to generate stubbed apps for testing
  """
  use ExUnit.CaseTemplate

  def create_app_stub do
    Bypass.open(port: 8080)
  end

  @fake_app_url "/"

  def stub_app(bypass, app_name) do
    Bypass.stub(bypass, "POST", @fake_app_url, &handle_request(&1, app_name))

    {bypass, app_name}
  end

  @spec stub_request_once(tuple(), map() | {:error, number(), String.t()}) :: tuple()
  def stub_request_once({_bypass, app_name} = app, result) do
    push(app_name, result)
    app
  end

  defp handle_request(conn, app_name) do
    {:ok, _, _} = Plug.Conn.read_body(conn)

    result = pop(app_name)

    case result do
      {:error, code, message} ->
        Plug.Conn.resp(conn, code, message)

      data ->
        Plug.Conn.resp(conn, 200, Jason.encode!(data))
    end
  end

  def init do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def pop(app_name) do
    case Agent.get(__MODULE__, &Map.get(&1, app_name, [])) do
      [head | tail] ->
        Agent.update(__MODULE__, &Map.put(&1, app_name, tail))
        head

      [] ->
        raise "App Stub Helper : No stub for app #{app_name}. You probably forgot a call case."
    end
  end

  def push(app_name, result) do
    Agent.update(__MODULE__, &Map.put(&1, app_name, Map.get(&1, app_name, []) ++ [result]))
  end
end
