defmodule DevTool.Environment do
  @moduledoc """
    The application schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias DevTool.Environment

  schema "environments" do
    timestamps()
  end

  def changeset(application, params \\ %{}) do
    application
    |> cast(params, [:id])
  end

  def new(params \\ %{}) do
    %Environment{}
    |> changeset(params)
  end

  def update(app, params) do
    app
    |> changeset(params)
  end
end
