defmodule DevTool.Repo do
  use Ecto.Repo,
    otp_app: :dev_tools,
    adapter: Ecto.Adapters.Postgres
end
