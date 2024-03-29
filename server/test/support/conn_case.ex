defmodule DevTool.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use DevTool.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias DevTool.Repo
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import DevTool.ConnCase

      import Ecto
      import Ecto.Query

      alias DevTool.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint DevTool.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(DevTool.Repo)

    unless tags[:async] do
      Sandbox.mode(DevTool.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
