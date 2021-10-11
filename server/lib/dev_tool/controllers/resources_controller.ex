defmodule DevTool.ResourcesController do
  use DevTool, :controller

  def get_app_resource(conn, %{"resource" => resource_name}) do
    url = Application.fetch_env!(:dev_tools, :application_url)

    headers = [{"Content-Type", "application/json"}]
    params = Map.put(%{}, :resource, resource_name)
    body = Jason.encode!(params)

    {:ok, resource_stream} = Finch.build(:post, url, headers, body)
    |> Finch.stream(AppHttp, [], fn
      chunk, acc -> acc ++ [chunk]
    end)

    conn =
      conn
      |> put_resp_content_type("image/event-stream")
      |> put_resp_header("Content-Type", "application/octet-stream")
      |> send_chunked(200)

    resource_stream
    |> Enum.reduce(conn, fn
      {:data, data}, conn ->
        {:ok, conn_res} =
          conn
          |> chunk(data)

        conn_res

      _, conn ->
        conn
    end)
  end
end
