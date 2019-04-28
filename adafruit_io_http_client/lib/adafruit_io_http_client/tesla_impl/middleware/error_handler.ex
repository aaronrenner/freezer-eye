defmodule AdafruitIOHTTPClient.TeslaImpl.Middleware.ErrorHandler do
  @moduledoc false

  alias AdafruitIOHTTPClient.HTTPClientError
  alias AdafruitIOHTTPClient.UnexpectedStatusCodeError
  alias Tesla.Env

  @behaviour Tesla.Middleware

  @impl true
  def call(env, next, _opts) do
    env
    |> Tesla.run(next)
    |> translate_error()
  end

  defp translate_error({:error, reason}) when is_atom(reason) do
    {:error, HTTPClientError.exception(reason: reason)}
  end

  defp translate_error({:ok, %Env{status: status} = env}) when status >= 200 and status <= 299,
    do: {:ok, env}

  defp translate_error({:ok, %Env{status: status, body: body}}) do
    {:error, UnexpectedStatusCodeError.exception(status_code: status, response_body: body)}
  end
end
