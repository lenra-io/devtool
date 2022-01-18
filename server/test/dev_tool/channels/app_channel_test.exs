defmodule DevTool.AppChannelTest do
  @moduledoc """
    Test the `DevTool.AppChannel` module
  """
  use DevTool.ChannelCase

  alias ApplicationRunner.ListenersCache
  alias DevTool.AppStub

  setup do
    socket = socket(DevTool.UserSocket, "socket_id", %{})
    bypass = AppStub.create_app_stub()

    %{socket: socket, bypass: bypass}
  end

  test "No app called, should return an error", %{socket: socket, bypass: _bypass} do
    res = my_subscribe_and_join(socket)
    assert {:error, %{reason: "No App Name"}} == res
    refute_push("ui", _)
  end

  @app_name "Counter"
  @listener_name "HiBob"
  @listener_code ListenersCache.generate_listeners_key(@listener_name, %{})

  @manifest %{"manifest" => %{"entrypoint" => "test"}}

  @data %{"data" => %{"user" => %{"name" => "World"}}}
  @data2 %{"data" => %{"user" => %{"name" => "Bob"}}}

  @textfield %{
    "type" => "textfield",
    "value" => "Hello World",
    "onChanged" => %{"action" => @listener_name}
  }

  @textfield2 %{
    "type" => "textfield",
    "value" => "Hello Bob",
    "onChanged" => %{"action" => @listener_name}
  }

  @transformed_textfield %{
    "type" => "textfield",
    "value" => "Hello World",
    "onChanged" => %{"code" => @listener_code}
  }

  @widget %{"widget" => %{"type" => "flex", "children" => [@textfield]}}
  @widget2 %{"widget" => %{"type" => "flex", "children" => [@textfield2]}}

  @expected_ui %{"root" => %{"type" => "flex", "children" => [@transformed_textfield]}}
  @expected_patch_ui %{
    "patch" => [%{"op" => "replace", "path" => "/root/children/0/value", "value" => "Hello Bob"}]
  }

  test "test base app", %{socket: socket, bypass: bypass} do
    AppStub.stub_app(bypass, @app_name)
    |> AppStub.stub_request_once(@manifest)
    |> AppStub.stub_request_once(@data)
    |> AppStub.stub_request_once(@widget)
    |> AppStub.stub_request_once(@data2)
    |> AppStub.stub_request_once(@widget2)

    {:ok, _, socket} = my_subscribe_and_join(socket, %{"app" => @app_name})

    assert %{session_pid: pid} = socket.assigns
    assert is_pid(pid)

    assert_push("ui", @expected_ui)

    push(socket, "run", %{"code" => @listener_code})

    assert_push("patchUi", @expected_patch_ui)

    Process.unlink(socket.channel_pid)
    ref = leave(socket)

    assert_reply(ref, :ok)
  end

  defp my_subscribe_and_join(socket, params \\ %{}) do
    subscribe_and_join(socket, DevTool.AppChannel, "app", params)
  end
end
