defmodule AdafruitIOHTTPClient.TeslaImpl.Middleware.CreateDatapointResponse do
  @moduledoc false

  alias AdafruitIOHTTPClient.Datapoint
  alias AdafruitIOHTTPClient.UnexpectedResponseFormatError
  alias Tesla.Env

  @behaviour Tesla.Middleware

  @impl true
  def call(env, next, _opts) do
    with {:ok, env} <- Tesla.run(env, next) do
      parse_response(env)
    end
  end

  defp parse_response(%Env{body: %{"id" => id, "value" => value}}) do
    {:ok, %Datapoint{id: id, value: value}}
  end

  defp parse_response(%Env{body: body}) do
    {:error, UnexpectedResponseFormatError.exception(response_body: body)}
  end
end
