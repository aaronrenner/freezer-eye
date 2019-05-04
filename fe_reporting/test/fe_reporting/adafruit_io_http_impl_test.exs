defmodule FEReporting.AdafruitIOHTTPImplTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias AdafruitIOHTTPClient.Datapoint
  alias FEReporting.AdafruitIOHTTPImpl
  alias FEReporting.AdafruitIOHTTPImpl.Config
  alias FEReporting.AdafruitIOHTTPImpl.MockConfig
  alias FEReporting.AdafruitIOHTTPImpl.MockAdafruitIOHTTPClient

  import Mox

  setup [:set_mox_from_context, :verify_on_exit!]

  property "send_heartbeat/0 calls the create_datapoint on AdafruitIOHTTPClient" do
    check all %Config{heartbeat_feed: heartbeat_feed, heartbeat_value: heartbeat_value} = config <-
                config() do
      expect(MockConfig, :fetch!, fn -> config end)

      expect(MockAdafruitIOHTTPClient, :create_datapoint, fn ^heartbeat_feed,
                                                             ^heartbeat_value,
                                                             _opts ->
        {:ok, %Datapoint{id: "123", value: heartbeat_value}}
      end)

      assert :ok = AdafruitIOHTTPImpl.send_heartbeat()
    end
  end

  defp config do
    [
      username: string(:alphanumeric),
      secret_key: string(:alphanumeric),
      heartbeat_feed: string(:alphanumeric),
      heartbeat_value: integer()
    ]
    |> fixed_list()
    |> map(&struct!(Config, &1))
  end
end
