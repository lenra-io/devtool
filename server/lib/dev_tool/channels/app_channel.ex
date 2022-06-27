defmodule DevTool.AppChannel do
  @moduledoc """
    `LenraWeb.AppChannel` handle the app channel to run app and listeners and push to the user the resulted UI or Patch
  """
  use ApplicationRunner.AppChannel

  defp allow(_user_id, _app_name) do
    :ok
  end

  defp get_function_name(_app_name) do
    %{function_name: "test"}
  end
end
