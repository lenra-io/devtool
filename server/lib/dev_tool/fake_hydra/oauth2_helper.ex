defmodule DevTool.FakeHydra.OAuth2Helper do
  @moduledoc """
    Helper function to create Oauth2 code/token and check them.
  """
  alias DevTool.Errors.BusinessError
  alias Phoenix.Token

  @encrypt_salt "devtool_encrypt_salt"
  @sign_salt "devtool_sign_salt"

  def generate_code(scope) do
    Token.encrypt(DevTool.FakeHydra.Endpoint, @encrypt_salt, %{scope: scope})
  end

  def generate_token(code) do
    with {:ok, claims} <- claims_from_code(code) do
      {:ok, Token.sign(DevTool.FakeHydra.Endpoint, @sign_salt, claims), claims}
    end
  end

  def generate_fake_token(scope) do
    Token.sign(DevTool.FakeHydra.Endpoint, @sign_salt, %{scope: scope})
  end

  def verify_scope(token, needed_scope) do
    IO.inspect(token)
    IO.inspect(needed_scope)

    with {:ok, %{scope: token_scope}} <- IO.inspect(claims_from_token(token)),
         true <- scopes_matches(token_scope, needed_scope) do
      {:ok, needed_scope}
    else
      false -> BusinessError.invalid_oauth2_scopes_tuple()
      err -> err
    end
  end

  defp claims_from_code(code) do
    case Token.decrypt(DevTool.FakeHydra.Endpoint, @encrypt_salt, code) do
      {:ok, claims} -> {:ok, claims}
      {:error, _reason} -> BusinessError.invalid_oauth2_code_tuple()
    end
  end

  def claims_from_token(token) do
    IO.inspect("claims_from_token")
    IO.inspect(Token.verify("Lhk7igVi9p3jnV9gMqi7+pSFFfo7R3V9PnXXt1FnvyHSqjYFThwDecnS1TmR2hUE", @sign_salt, token))
    case IO.inspect(Token.verify(DevTool.FakeHydra.Endpoint, @sign_salt, token)) do
      {:ok, claims} -> {:ok, claims}
      {:error, _reason} -> BusinessError.invalid_oauth2_token_tuple()
    end
  end

  defp scopes_matches(token_scope, needed_scope) do
    needed_scope_list = String.split(needed_scope)
    token_scope_list = String.split(token_scope)

    Enum.all?(needed_scope_list, fn scope -> scope in token_scope_list end)
  end
end
