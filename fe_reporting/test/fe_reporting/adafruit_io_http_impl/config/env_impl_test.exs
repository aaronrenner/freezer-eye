defmodule FEReporting.AdafruitIOHTTPImpl.Config.EnvImplTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias FEReporting.AdafruitIOHTTPImpl.Config
  alias FEReporting.AdafruitIOHTTPImpl.Config.EnvImpl

  setup do
    ensure_setting_is_reset(:fe_reporting, :adafruit_io_config_impl)
  end

  property "fetch!/0 returns a config struct with the proper values" do
    check all config <-
                [
                  username: string(:alphanumeric),
                  secret_key: string(:alphanumeric),
                  heartbeat_feed: string(:alphanumeric),
                  heartbeat_value: string(:alphanumeric),
                  base_url: one_of([string(:alphanumeric), nil])
                ]
                |> fixed_list()
                |> sublist_of() do
      Application.put_env(:fe_reporting, :adafruit_io, config)

      if has_required_keys?(config, [:username, :secret_key, :heartbeat_feed, :heartbeat_value]) do
        assert %Config{
                 username: Keyword.fetch!(config, :username),
                 secret_key: Keyword.fetch!(config, :secret_key),
                 heartbeat_feed: Keyword.fetch!(config, :heartbeat_feed),
                 heartbeat_value: Keyword.fetch!(config, :heartbeat_value),
                 base_url: Keyword.get(config, :base_url)
               } == EnvImpl.fetch!()
      else
        assert_raise KeyError, fn ->
          EnvImpl.fetch!()
        end
      end
    end
  end

  defp ensure_setting_is_reset(application, key) do
    original_result = Application.fetch_env(application, key)

    on_exit(fn ->
      case original_result do
        {:ok, original_value} ->
          Application.put_env(application, key, original_value)

        :error ->
          Application.delete_env(application, key)
      end
    end)
  end

  defp has_required_keys?(keyword_list, required_keys) do
    actual_keys = keyword_list |> Keyword.keys() |> MapSet.new()
    required_keys = MapSet.new(required_keys)

    MapSet.subset?(required_keys, actual_keys)
  end

  defp sublist_of(list_generator) do
    gen all list <- list_generator,
            final_size <- integer(0..length(list)) do
      list |> Enum.shuffle() |> Enum.take(final_size)
    end
  end
end
