defmodule FETestHelpers.HeartbeatTrackerTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias FETestHelpers.HeartbeatTracker

  property "record_heartbeat/1 stores the current timestamp in order each time it's called" do
    forall [heartbeat_count <- pos_integer()] do
      {:ok, tracker} = HeartbeatTracker.start_link([])

      record_heartbeat_multiple_times(tracker, heartbeat_count)

      timestamps = HeartbeatTracker.list_heartbeat_timestamps(tracker)

      timestamps_sorted? =
        Enum.sort_by(timestamps, &DateTime.to_unix(&1, :nanosecond)) == timestamps

      timestamps_sorted?
    end
  end

  property "count/1 returns the number of heartbeats recorded" do
    forall [heartbeat_count <- non_neg_integer()] do
      {:ok, tracker} = HeartbeatTracker.start_link([])

      record_heartbeat_multiple_times(tracker, heartbeat_count)

      heartbeat_count == HeartbeatTracker.count(tracker)
    end
  end

  property "list_heartbeat_intervals/1 returns non negative values when only calling record_heartbeat/1" do
    forall [
      heartbeat_count <- integer(2, :inf),
      time_unit <- oneof([:second, :millisecond, :microsecond, :nanosecond])
    ] do
      {:ok, tracker} = HeartbeatTracker.start_link([])

      record_heartbeat_multiple_times(tracker, heartbeat_count)

      intervals = HeartbeatTracker.list_heartbeat_intervals(tracker, time_unit)

      intervals_all_non_negative? = Enum.all?(intervals, &(&1 >= 0))
      correct_interval_count? = length(intervals) == heartbeat_count - 1

      intervals_all_non_negative? && correct_interval_count?
    end
  end

  defp record_heartbeat_multiple_times(tracker, times) when is_integer(times) and times > 0 do
    :ok = HeartbeatTracker.record_heartbeat(tracker)
    record_heartbeat_multiple_times(tracker, times - 1)
  end

  defp record_heartbeat_multiple_times(_tracker, 0), do: :ok
end
