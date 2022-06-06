defmodule DevTool.DataController do
  use DevTool, :controller

  alias DevTool.DataServices

  @fake_env_id 1
  @fake_user_id 1

  def get(conn, params) do
    with result <- DataServices.get(@fake_env_id, params["_datastore"], params["_id"]) do
      conn
      |> assign_all(result.data)
      |> reply
    end
  end

  def get_all(conn, params) do
    with result <- DataServices.get_all(@fake_env_id, params["_datastore"]) do
      conn
      |> assign_all(Enum.map(result, fn r -> r.data end))
      |> reply
    end
  end

  def get_me(conn, _params) do
    with result <-
           DataServices.get_me(@fake_env_id, @fake_user_id) do
      conn
      |> assign_all(result.data)
      |> reply
    end
  end

  def create(conn, params) do
    with {:ok, %{inserted_data: data}} <- DataServices.create(@fake_env_id, params),
         result <- DataServices.get(@fake_env_id, params["_datastore"], data.id) do
      conn
      |> assign_all(result.data)
      |> reply
    end
  end

  def update(conn, params) do
    with {:ok, %{updated_data: data}} <- DataServices.update(params),
         result <- DataServices.get(@fake_env_id, params["_datastore"], data.id) do
      conn
      |> assign_all(result.data)
      |> reply
    end
  end

  def delete(conn, params) do
    with {:ok, %{deleted_data: data}} <- DataServices.delete(params["_id"]) do
      conn
      |> assign_data(:deleted_data, data)
      |> reply
    end
  end

  def query(conn, params) do
    data =
      DataServices.parse_and_exec_query(
        params,
        @fake_env_id,
        @fake_user_id
      )

    conn
    |> assign_all(data)
    |> reply
  end
end
