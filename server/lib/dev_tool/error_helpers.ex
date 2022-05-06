defmodule DevTool.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  @errors [
    unknow_error: %{code: 0, message: "Unknown error"},
    password_not_equals: %{code: 1, message: "Password must be equals."},
    parameters_null: %{code: 2, message: "Parameters can't be null."},
    no_validation_code: %{
      code: 3,
      message: "There is no validation code for this user."
    },
    unhandled_resource_type: %{code: 7, message: "Unknown resource."},
    listener_not_found: %{code: 18, message: "No listener found in app manifest."},
    timeout: %{code: 20, message: "Openfaas timeout."},
    no_app_found: %{code: 21, message: "No application found for the current link."},
    widget_not_found: %{code: 23, message: "No Widget found in app manifest."},
    invalid_ui: %{code: 25, message: "Invalid UI"},
    datastore_not_found: %{code: 26, message: "Datastore cannot be found"},
    data_not_found: %{code: 27, message: "Data cannot be found"},
    bad_request: %{
      code: 400,
      message: "Server cannot understand or process the request due to a client-side error."
    },
    error_404: %{code: 404, message: "Not Found."},
    error_500: %{code: 500, message: "Internal server error."},
    openfaas_not_reachable: %{code: 1000, message: "Openfaas is not accessible"},
    forbidden: %{code: 403, message: "Forbidden"}
  ]

  def translate_errors([]), do: []
  def translate_errors([err | errs]), do: translate_error(err) ++ translate_errors(errs)

  def translate_error(%Ecto.Changeset{errors: errors}) do
    Enum.map(errors, &translate_ecto_error/1)
  end

  def translate_error(err) when is_atom(err) do
    [Keyword.get(@errors, err, %{code: 0, message: "Unknown error"})]
  end

  def translate_ecto_error({field, {msg, opts}}) do
    message =
      Enum.reduce(opts, "#{field} #{msg}", fn
        {_key, {:parameterized, _, _}}, acc -> acc
        {key, value}, acc -> String.replace(acc, "%{#{key}}", to_string(value))
      end)

    %{code: 0, message: message}
  end
end
