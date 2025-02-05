defmodule DevTool.FakeHydra.Oauth2Controller do
  alias DevTool.UserServices
  use DevTool, :controller

  alias DevTool.FakeHydra.Oauth2Helper
  alias DevTool.{Repo, User}
  require Logger

  def auth(conn, %{"redirect_uri" => redirect_uri, "scope" => scope, "state" => state}) do
    users =
      case Enum.map(Repo.all(User), fn user -> user.manual_id end) do
        [] ->
          {:ok, _user} = UserServices.upsert_fake_user(1)
          [1]

        ids ->
          Enum.sort(ids)
      end

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
    code = Oauth2Helper.generate_code(scope, user_id)
    encoded_params = URI.encode_query(%{"code" => code, "state" => state})
    redirect(conn, external: "#{uri}?#{encoded_params}")
  end

  # defp encode_token(scope, )

  def token(conn, %{"code" => code}) do
    with {:ok, token, %{scope: scope}} <- Oauth2Helper.generate_token(code) do
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
    resp(conn, 200, "")
  end

  def logout(conn, _params) do
    render(
      conn,
      "logout.html"
    )
  end
end
