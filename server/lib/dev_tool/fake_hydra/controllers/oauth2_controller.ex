defmodule DevTool.FakeHydra.OAuth2Controller do
  alias DevTool.UserServices
  use DevTool, :controller

  alias DevTool.FakeHydra.OAuth2Helper
  alias DevTool.{Repo, User}
  require Logger

  def auth(conn, %{"redirect_uri" => redirect_uri, "scope" => scope, "state" => state}) do
    users =
      Enum.map(Repo.all(User), fn user -> user.manual_id end)
      |> Enum.sort()

    next_id = Enum.max(users) + 1

    render(
      conn,
      "choose-user.html",
      users: users,
      next_id: next_id,
      redirect_uri: redirect_uri,
      scope: scope,
      state: state
    )
  end

  def user(conn, %{"user" => user_id, "redirect_uri" => uri, "scope" => scope, "state" => state}) do
    UserServices.upsert_fake_user(user_id)
    code = OAuth2Helper.generate_code(scope, user_id)
    encoded_params = URI.encode_query(%{"code" => code, "state" => state})
    redirect(conn, external: "#{uri}?#{encoded_params}")
  end

  # defp encode_token(scope, )

  def token(conn, %{"code" => code}) do
    with {:ok, token, %{scope: scope}} <- OAuth2Helper.generate_token(code) do
      response = %{
        access_token: token,
        expire_in: 3600,
        scope: scope,
        token_type: "bearer"
      }

      json(conn, response)
    end
  end

  def revoke(conn, _params) do
    resp(conn, 200, "ok")
  end
end
