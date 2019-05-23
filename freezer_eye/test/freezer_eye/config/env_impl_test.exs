defmodule FreezerEye.Config.EnvImplTest do
  use ExUnit.Case
  use ExUnitProperties

  alias FreezerEye.Config.EnvImpl
  alias FreezerEye.Config

  setup do
    ensure_setting_is_reset(:freezer_eye, :heartbeat_interval)
  end

  property "fetch!/0 returns a config struct with the proper values" do
    config_value_generators = [
      heartbeat_interval: positive_integer()
    ]

    check all config <-
                config_value_generators
                |> fixed_list()
                |> sublist_of() do
      config_value_generators
      |> Keyword.keys()
      |> Enum.each(&Application.delete_env(:freezer_eye, &1))

      Enum.each(config, fn {key, value} ->
        Application.put_env(:freezer_eye, key, value)
      end)

      if has_required_keys?(config, [:heartbeat_interval]) do
        assert %Config{
                 heartbeat_interval: Keyword.fetch!(config, :heartbeat_interval)
               } == EnvImpl.fetch!()
      else
        assert_raise ArgumentError, fn ->
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
