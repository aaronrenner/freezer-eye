defmodule FEReporting.AdafruitIOHTTPImpl.Config.EnvImpl do
  @moduledoc false

  alias FEReporting.AdafruitIOHTTPImpl.Config

  @spec fetch!() :: Config.t() | none
  def fetch! do
    env = Application.fetch_env!(:fe_reporting, :adafruit_io)

    %Config{
      username: Keyword.fetch!(env, :username),
      secret_key: Keyword.fetch!(env, :secret_key),
      heartbeat_feed: Keyword.fetch!(env, :heartbeat_feed),
      heartbeat_value: Keyword.fetch!(env, :heartbeat_value),
      base_url: Keyword.get(env, :base_url)
    }
  end
end
