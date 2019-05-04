defmodule FEReporting.AdafruitIOHTTPImpl do
  @moduledoc false

  alias FEReporting.AdafruitIOHTTPImpl.Config

  @behaviour FEReporting.Impl

  @impl true
  @spec send_heartbeat :: :ok
  def send_heartbeat do
    %Config{heartbeat_feed: heartbeat_feed, heartbeat_value: heartbeat_value} =
      config = Config.fetch!()

    adafruit_config = build_adafruit_config(config)

    AdafruitIOHTTPClient.create_datapoint(heartbeat_feed, heartbeat_value, config: adafruit_config)

    :ok
  end

  @spec build_adafruit_config(Config.t()) :: AdafruitIOHTTPClient.Config.t()
  defp build_adafruit_config(%Config{username: username, secret_key: secret_key}) do
    AdafruitIOHTTPClient.Config.new(username, secret_key)
  end
end
