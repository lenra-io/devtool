defmodule DevTool.AppChannelTest do
  @moduledoc """
    Test the `DevTool.AppChannel` module
  """
  use DevTool.ChannelCase

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
  @build_number 1
  @listener_name "HiBob"
  @listener_code "#{@listener_name}:{}"

  @data %{"user" => %{"name" => "World"}}
  @data2 %{"user" => %{"name" => "Bob"}}

  @listeners %{"onChange" => %{"action" => @listener_name}}
  @transformed_listeners %{"onChange" => %{"code" => @listener_code}}

  @textfield %{
    "type" => "textfield",
    "value" => "Hello World",
    "listeners" => @listeners
  }

  @textfield2 %{
    "type" => "textfield",
    "value" => "Hello Bob",
    "listeners" => @listeners
  }

  @transformed_textfield %{
    "type" => "textfield",
    "value" => "Hello World",
    "listeners" => @transformed_listeners
  }

  @ui %{"root" => %{"type" => "container", "children" => [@textfield]}}
  @ui2 %{"root" => %{"type" => "container", "children" => [@textfield2]}}

  @expected_ui %{"root" => %{"type" => "container", "children" => [@transformed_textfield]}}
  @expected_patch_ui %{
    patch: [%{"op" => "replace", "path" => "/root/children/0/value", "value" => "Hello Bob"}]
  }

  test "test base app", %{socket: socket, bypass: bypass} do
    AppStub.stub_app(bypass, @app_name)
    |> AppStub.stub_action_once("InitData", %{"data" => @data, "ui" => @ui})
    |> AppStub.stub_action_once(@listener_name, %{"data" => @data2, "ui" => @ui2})

    {:ok, _, socket} = my_subscribe_and_join(socket, %{"app" => @app_name})

    assert socket.assigns == %{app_name: @app_name, build_number: @build_number}

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
