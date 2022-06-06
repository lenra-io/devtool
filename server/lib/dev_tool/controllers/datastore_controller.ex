defmodule DevTool.DatastoreController do
  use DevTool, :controller

  alias DevTool.DatastoreServices

  @fake_env_id 1

  def create(conn, params) do
    with {:ok, %{inserted_datastore: datastore}} <- DatastoreServices.create(@fake_env_id, params) do
      conn
      |> assign_data(:inserted_datastore, datastore)
      |> reply
    end
  end

  def delete(conn, params) do
    with {:ok, %{deleted_datastore: datastore}} <-
           DatastoreServices.delete(params["datastore"], @fake_env_id) do
      conn
      |> assign_data(:deleted_datastore, datastore)
      |> reply
    end
  end
end
