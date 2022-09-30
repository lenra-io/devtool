defmodule DevTool.WebhooksControllerTest do
  use DevTool.ConnCase, async: true

  alias ApplicationRunner.Webhooks.WebhookServices

  setup %{conn: conn} do
    {:ok, user} = DevTool.UserServices.upsert_fake_user(1)
    {:ok, %{conn: conn, user: user}}
  end

  test "Get env webhooks should work properly", %{conn: conn} do
    WebhookServices.create(1, %{"action" => "test"})

    conn = get(conn, Routes.webhooks_path(conn, :index), %{"env_id" => 1})

    assert [webhook] = json_response(conn, 200)
    assert webhook["action"] == "test"
    assert webhook["environment_id"] == 1
  end

  test "Get session webhooks should work properly", %{conn: conn, user: user} do
    WebhookServices.create(1, %{
      "action" => "test",
      "user_id" => user.id
    })

    conn = get(conn, Routes.webhooks_path(conn, :index), %{"env_id" => 1, "user_id" => user.id})

    assert [webhook] = json_response(conn, 200)
    assert webhook["action"] == "test"
    assert webhook["environment_id"] == 1
    assert webhook["user_id"] == user.id
  end

  test "Get with no webhooks in db should work properly", %{conn: conn} do
    conn = get(conn, Routes.webhooks_path(conn, :index), %{"env_id" => 1})

    assert [] == json_response(conn, 200)
  end

  test "Create webhook should work properly", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :api_create), %{
        "env_id" => 1,
        "action" => "test",
        "user_id" => user.id
      })

    assert %{"action" => "test"} = json_response(conn, 200)

    conn = get(conn, Routes.webhooks_path(conn, :index), %{"env_id" => 1})

    assert [webhook] = json_response(conn, 200)
    assert webhook["action"] == "test"
    assert webhook["environment_id"] == 1
  end
end
