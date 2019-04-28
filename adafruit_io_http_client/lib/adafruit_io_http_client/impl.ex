defmodule AdafruitIOHTTPClient.Impl do
  @moduledoc false

  alias AdafruitIOHTTPClient.Datapoint
  alias AdafruitIOHTTPClient.HTTPClientError
  alias AdafruitIOHTTPClient.UnexpectedStatusCodeError

  @type feed_key :: AdafruitIOHTTPClient.feed_key()

  @callback create_datapoint(feed_key, Datapoint.value(), [
              AdafruitIOHTTPClient.create_datapoint_opt()
            ]) ::
              {:ok, Datapoint.t()} | {:error, HTTPClientError.t() | UnexpectedStatusCodeError.t()}
end
