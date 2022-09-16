defmodule DevTool.User do
  @moduledoc """
    The user schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias DevTool.User

  schema "users" do
    field(:email, :string)
    field(:manual_id, :id)
    timestamps()
  end

  def changeset(application, params \\ %{}) do
    application
    |> cast(params, [:id, :manual_id, :email])
    |> validate_required([:email, :manual_id])
  end

  def new(params \\ %{}) do
    %User{}
    |> changeset(params)
  end

  def update(app, params) do
    app
    |> changeset(params)
  end
end
