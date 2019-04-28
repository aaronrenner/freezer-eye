defmodule AdafruitIOHTTPClient.Guards do
  @moduledoc false

  defguard is_feed_key(value) when is_binary(value)

  defguard is_datapoint_value(value) when is_binary(value) or is_number(value)
end
