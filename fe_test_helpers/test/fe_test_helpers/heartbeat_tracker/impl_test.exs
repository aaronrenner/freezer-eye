defmodule FETestHelpers.HeartbeatTracker.ImplTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias FETestHelpers.HeartbeatTracker.Impl

  test "record_heartbeat/1 records the heartbeat at the current time" do
    [recorded_timestamp] =
      Impl.new()
      |> Impl.record_heartbeat()
      |> Impl.list_heartbeat_timestamps()

    assert DateTime.diff(recorded_timestamp, DateTime.utc_now(), :millisecond) < 20
  end

  property "count/1 returns the number of recorded heartbeats" do
    forall heartbeat_count <- non_neg_integer() do
      impl = Impl.new() |> record_heartbeat_multiple_times(heartbeat_count)

      heartbeat_count == Impl.count(impl)
    end
  end

  property "list_heartbeat_timestamps/1 returns the timestamps in the order received" do
    current_timestamp = DateTime.utc_now()

    forall timestamps <- list(recent_timestamp(current_timestamp)) do
      impl =
        for timestamp <- timestamps, reduce: Impl.new() do
          impl -> Impl.record_heartbeat(impl, timestamp)
        end

      timestamps == Impl.list_heartbeat_timestamps(impl)
    end
  end

  property "list_heartbeat_intervals/1 returns the time since the previous heartbeat" do
    current_timestamp = DateTime.utc_now()

    forall intervals <- non_empty(list(integer())) do
      timestamps =
        intervals
        |> Enum.reduce([current_timestamp], fn interval, [last_timestamp | _] = timestamps ->
          timestamp = DateTime.add(last_timestamp, interval)

          [timestamp | timestamps]
        end)
        |> Enum.reverse()

      impl =
        for timestamp <- timestamps, reduce: Impl.new() do
          impl -> Impl.record_heartbeat(impl, timestamp)
        end

      intervals == Impl.list_heartbeat_intervals(impl)
    end
  end

  property "list_heartbeat_intervals/1 returns non negative values when only calling record_heartbeat/1" do
    forall [
      heartbeat_count <- integer(2, :inf),
      time_unit <- oneof([:second, :millisecond, :microsecond, :nanosecond])
    ] do
      impl = Impl.new() |> record_heartbeat_multiple_times(heartbeat_count)

      impl |> Impl.list_heartbeat_intervals(time_unit) |> Enum.all?(&(&1 >= 0))
    end
  end

  test "list_heartbeat_intervals/1 returns an empty array when heartbeat_count has been called less than twice" do
    for heartbeat_count <- 0..1 do
      impl = Impl.new() |> record_heartbeat_multiple_times(heartbeat_count)

      assert Impl.list_heartbeat_intervals(impl) == []
    end
  end

  @spec record_heartbeat_multiple_times(Impl.t(), non_neg_integer) :: Impl.t()
  defp record_heartbeat_multiple_times(impl, times) when is_integer(times) and times > 0 do
    impl |> Impl.record_heartbeat() |> record_heartbeat_multiple_times(times - 1)
  end

  defp record_heartbeat_multiple_times(impl, 0), do: impl

  defp recent_timestamp(%DateTime{} = base_timestamp) do
    let seconds_after <- integer() do
      DateTime.add(base_timestamp, seconds_after)
    end
  end
end
