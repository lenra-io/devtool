defmodule DevTool.DataController do
  use DevTool, :controller

  alias DevTool.DataServices

  @fake_env_id 1
  @fake_user_id 1

  def get(conn, params) do
    with data <- DataServices.get(params["_datastore"], params["_id"]) do
      conn
      |> assign_data(:data, data)
      |> reply
    end
  end

  def create(conn, params) do
    with {:ok, %{inserted_data: data}} <- DataServices.create(@fake_env_id, params) do
      conn
      |> assign_data(:inserted_data, data)
      |> reply
    end
  end

  def update(conn, params) do
    with {:ok, %{updated_data: data}} <- DataServices.update(params) do
      conn
      |> assign_data(:updated_data, data)
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
    with requested <-
           DataServices.query(
             @fake_env_id,
             @fake_user_id,
             params["query"]
           ) do
      conn
      |> assign_data(:requested, requested)
      |> reply
    end
  end
end
