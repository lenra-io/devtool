defmodule DevTool.ApplicationRunnerAdapterTest do
  @moduledoc """
    Test the Errors for the app runner adapter
  """
  use ExUnit.Case

  alias ApplicationRunner.SessionState
  alias DevTool.ApplicationRunnerAdapter

  setup do
    bypass = Bypass.open(port: 6789)
    {:ok, bypass: bypass}
  end

  test "get_manifest", %{bypass: bypass} do
    manifest = %{"rootWidget" => "test"}

    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 200, Jason.encode!(%{"manifest" => manifest}))
    end)

    assert {:ok, ^manifest} = ApplicationRunnerAdapter.get_manifest(%{})
  end

  test "get_manifest app not started", %{bypass: bypass} do
    Bypass.down(bypass)

    assert_raise RuntimeError,
                 "Application could not be reached. Make sure that the application is started.",
                 fn -> ApplicationRunnerAdapter.get_manifest(%{}) end

    Bypass.up(bypass)
  end

  test "get_manifest app error", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 500, "")
    end)

    assert_raise RuntimeError, "Application error (500) ", fn ->
      ApplicationRunnerAdapter.get_manifest(%{})
    end
  end

  test "get_widget", %{bypass: bypass} do
    widget = %{"type" => "text", "value" => "foo"}

    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 200, Jason.encode!(%{"widget" => widget}))
    end)

    assert {:ok, ^widget} = ApplicationRunnerAdapter.get_widget(%{}, "text", %{}, %{})
  end

  test "get_widget app not started", %{bypass: bypass} do
    Bypass.down(bypass)

    assert_raise RuntimeError,
                 "Application could not be reached. Make sure that the application is started.",
                 fn -> ApplicationRunnerAdapter.get_widget(%{}, "test", %{}, %{}) end

    Bypass.up(bypass)
  end

  test "get_widget app error", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 500, "")
    end)

    assert_raise RuntimeError, "Application error (500) ", fn ->
      ApplicationRunnerAdapter.get_widget(%{}, "test", %{}, %{})
    end
  end

  test "run_listener", %{bypass: bypass} do
    data = %{"foo" => "bar"}

    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 200, Jason.encode!(%{"data" => data}))
    end)

    assert {:ok, ^data} = ApplicationRunnerAdapter.run_listener(%{}, "action", %{}, %{}, %{})
  end

  test "run_listener app not started", %{bypass: bypass} do
    Bypass.down(bypass)

    assert_raise RuntimeError,
                 "Application could not be reached. Make sure that the application is started.",
                 fn -> ApplicationRunnerAdapter.run_listener(%{}, "action", %{}, %{}, %{}) end

    Bypass.up(bypass)
  end

  test "run_listener app error", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 500, "")
    end)

    assert_raise RuntimeError, "Application error (500) ", fn ->
      ApplicationRunnerAdapter.run_listener(%{}, "action", %{}, %{}, %{})
    end
  end

  test "get_data and save_data", %{bypass: _} do
    session_state = %SessionState{session_id: 1, env_id: 1}
    data = %{"foo" => "bar"}
    assert {:ok, %{}} = ApplicationRunnerAdapter.get_data(session_state)

    ApplicationRunnerAdapter.save_data(session_state, data)

    assert {:ok, ^data} = ApplicationRunnerAdapter.get_data(session_state)
  end
end
