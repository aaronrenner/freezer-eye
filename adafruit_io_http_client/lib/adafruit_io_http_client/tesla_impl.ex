defmodule AdafruitIOHTTPClient.TeslaImpl do
  @moduledoc false

  alias AdafruitIOHTTPClient.Config
  alias AdafruitIOHTTPClient.Datapoint
  alias AdafruitIOHTTPClient.HTTPClientError
  alias AdafruitIOHTTPClient.TeslaImpl.Middleware.CreateDatapointResponse
  alias AdafruitIOHTTPClient.UnexpectedStatusCodeError
  alias Tesla.Client

  @behaviour AdafruitIOHTTPClient.Impl

  @type feed_key :: AdafruitIOHTTPClient.feed_key()
  @type value :: Datapoint.value()

  @adapter Tesla.Adapter.Hackney

  @impl true
  @spec create_datapoint(feed_key, value, [AdafruitIOHTTPClient.create_datapoint_opt()]) ::
          {:ok, Datapoint.t()} | {:error, HTTPClientError.t() | UnexpectedStatusCodeError.t()}
  def create_datapoint(feed_key, value, opts) do
    %Config{username: username} =
      config = Keyword.get_lazy(opts, :config, &Config.load_from_env!/0)

    path = ["api", "v2", username, "feeds", feed_key, "data"] |> Enum.join("/")

    config
    |> build_client(CreateDatapointResponse)
    |> Tesla.post(path, %{"value" => value})
  end

  @spec build_client(Config.t(), module) :: Client.t()
  defp build_client(%Config{base_url: base_url, secret_key: secret_key}, parser) do
    middleware = [
      parser,
      {Tesla.Middleware.BaseUrl, base_url},
      {Tesla.Middleware.Headers, [{"x-aio-key", secret_key}]},
      AdafruitIOHTTPClient.TeslaImpl.Middleware.ErrorHandler,
      {Tesla.Middleware.JSON, encode_content_type: "application/json; charset=utf-8"},
      Tesla.Middleware.Logger
    ]

    Tesla.client(middleware, @adapter)
  end
end
