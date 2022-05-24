defmodule DevTool.ApplicationRunnerAdapterTest do
  @moduledoc """
    Test the Errors for the app runner adapter
  """
  use ExUnit.Case

  alias ApplicationRunner.SessionState
  alias DevTool.ApplicationRunnerAdapter

  setup do
    bypass = Bypass.open(port: 8080)
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

    assert {:error, _msg} = ApplicationRunnerAdapter.get_manifest(%{})

    Bypass.up(bypass)
  end

  test "get_manifest app error", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 500, "")
    end)

    assert {:error, msg} = ApplicationRunnerAdapter.get_manifest(%{})
    assert String.contains?(msg, "Application error (500) ")
  end

  test "get_widget", %{bypass: bypass} do
    widget = %{"type" => "text", "value" => "foo"}

    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 200, Jason.encode!(%{"widget" => widget}))
    end)

    assert {:ok, ^widget} = ApplicationRunnerAdapter.get_widget(%{}, "text", %{}, %{}, %{})
  end

  test "get_widget app not started", %{bypass: bypass} do
    Bypass.down(bypass)

    assert {:error, _msg} = ApplicationRunnerAdapter.get_widget(%{}, "test", %{}, %{}, %{})

    Bypass.up(bypass)
  end

  test "get_widget app error", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/", fn conn ->
      Plug.Conn.resp(conn, 500, "")
    end)

    assert {:error, msg} = ApplicationRunnerAdapter.get_widget(%{}, "test", %{}, %{}, %{})
    assert String.contains?(msg, "Application error (500) ")
  end

  # test "run_listener", %{bypass: bypass} do
  #   data = %{"foo" => "bar"}

  #   Bypass.expect_once(bypass, "POST", "/", fn conn ->
  #     Plug.Conn.resp(conn, 200, Jason.encode!(%{"data" => data}))
  #   end)

  #   assert {:ok, ^data} =
  #            ApplicationRunnerAdapter.run_listener(
  #              %SessionState{session_id: 1, env_id: 1},
  #              "action",
  #              %{},
  #              %{}
  #            )
  # end

  # test "run_listener app not started", %{bypass: bypass} do
  #   Bypass.down(bypass)

  #   assert {:error, _msg} =
  #            ApplicationRunnerAdapter.run_listener(
  #              %SessionState{session_id: 1, env_id: 1},
  #              "action",
  #              %{},
  #              %{}
  #            )

  #   Bypass.up(bypass)
  # end

  # test "run_listener app error", %{bypass: bypass} do
  #   Bypass.expect_once(bypass, "POST", "/", fn conn ->
  #     Plug.Conn.resp(conn, 500, "")
  #   end)

  #   assert {:error, msg} =
  #            ApplicationRunnerAdapter.run_listener(
  #              %SessionState{},
  #              "action",
  #              %{},
  #              %{},
  #              %{}
  #            )

  #   assert String.contains?(msg, "Application error (500) ")
  # end
end
