defmodule DevTool.Errors.BusinessError do
  @moduledoc """
    DevTool.Errors.BusinessError handles business errors for the Lenra app.
    This module uses LenraCommon.Errors.BusinessError
  """

  use LenraCommon.Errors.ErrorGenerator,
    module: LenraCommon.Errors.BusinessError,
    inherit: true,
    errors: [
      {:null_parameters, "Parameters can't be null."},
      {:invalid_oauth2_code, "Invalid code"},
      {:invalid_oauth2_token, "Invalid token", 401},
      {:invalid_oauth2_scopes, "Scopes are insufficient", 401}
    ]
end
