defmodule DevTool.Errors.TechnicalError do
  @moduledoc """
    DevTool.Errors.TechnicalError handles technical errors for the Lenra app.
    This module uses LenraCommon.Errors.TechnicalError
  """

  use LenraCommon.Errors.ErrorGenerator,
    module: LenraCommon.Errors.TechnicalError,
    inherit: true,
    errors: []
end
