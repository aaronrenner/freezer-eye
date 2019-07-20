defmodule AdafruitIOHTTPClient do
  @moduledoc """
  API Client for Adafruit.io's V2 HTTP API
  """

  import AdafruitIOHTTPClient.Guards

  alias AdafruitIOHTTPClient.Config
  alias AdafruitIOHTTPClient.Datapoint
  alias AdafruitIOHTTPClient.HTTPClientError
  alias AdafruitIOHTTPClient.TeslaImpl
  alias AdafruitIOHTTPClient.UnexpectedStatusCodeError

  @behaviour AdafruitIOHTTPClient.Impl

  @type feed_key :: String.t()
  @type config_opt :: {:config, Config.t()}

  @type create_datapoint_opt :: config_opt

  @doc """
  Creates a new datapoint on the given feed
  """
  @impl true
  @spec create_datapoint(feed_key, Datapoint.value(), [create_datapoint_opt]) ::
          {:ok, Datapoint.t()} | {:error, HTTPClientError.t() | UnexpectedStatusCodeError.t()}
  def create_datapoint(feed_key, value, opts \\ [])
      when is_feed_key(feed_key) and is_datapoint_value(value) do
    impl().create_datapoint(feed_key, value, opts)
  end

  defp impl do
    Application.get_env(:adafruit_io_http_client, :impl, TeslaImpl)
  end
end
