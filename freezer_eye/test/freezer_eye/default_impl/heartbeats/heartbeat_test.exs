defmodule FreezerEye.DefaultImpl.Heartbeats.HeartbeatTest do
  use ExUnit.Case, async: true

  alias FETestHelpers.HeartbeatTracker
  alias FreezerEye.DefaultImpl.Heartbeats.Heartbeat

  defmodule MockHeartbeatReporter do
    @moduledoc false

    def start_link(opts) when is_list(opts) do
      Agent.start_link(fn -> 0 end)
    end

    def send_heartbeat(pid, fun) when is_function(fun) do
      count = Agent.get_and_update(pid, fn state -> {state, state + 1} end)

      fun.(count)
    end
  end

  test "start_link/1 calls the given function every interval" do
    {:ok, tracker} = HeartbeatTracker.start_link([])
    interval = 200

    {:ok, _pid} =
      Heartbeat.start_link(
        interval: interval,
        heartbeat_fn: fn ->
          HeartbeatTracker.record_heartbeat(tracker)
        end
      )

    Process.sleep(1_000)

    assert 5 = HeartbeatTracker.count(tracker)

    for actual_interval <- HeartbeatTracker.list_heartbeat_intervals(tracker, :millisecond) do
      assert_in_delta(actual_interval, interval, 20)
    end
  end

  @tag :capture_log
  test "continues sending heartbeats even when a heartbeat raises an exception" do
    {:ok, tracker} = HeartbeatTracker.start_link([])
    interval = 200

    {:ok, mock_reporter} = MockHeartbeatReporter.start_link([])

    {:ok, _pid} =
      Heartbeat.start_link(
        interval: interval,
        heartbeat_fn: fn ->
          MockHeartbeatReporter.send_heartbeat(mock_reporter, fn
            2 ->
              raise "foo"

            _ ->
              HeartbeatTracker.record_heartbeat(tracker)
          end)
        end
      )

    Process.sleep(1_000)

    assert 4 = HeartbeatTracker.count(tracker)

    expected_intervals = [200, 400, 200, 200]
    actual_intervals = HeartbeatTracker.list_heartbeat_intervals(tracker, :millisecond)

    for {expected, actual} <- Enum.zip([expected_intervals, actual_intervals]) do
      assert_in_delta(expected, actual, 20)
    end
  end

  @tag :capture_log
  test "stop/1 stops all in progress heartbeats" do
    {:ok, tracker} = HeartbeatTracker.start_link([])
    interval = 200

    {:ok, heartbeat} =
      Heartbeat.start_link(
        interval: interval,
        heartbeat_fn: fn ->
          Process.sleep(1_000)
          HeartbeatTracker.record_heartbeat(tracker)
        end
      )

    Process.sleep(300)

    Heartbeat.stop(heartbeat)

    assert 0 = HeartbeatTracker.count(tracker)

    # Ensure current heartbeat function was killed
    Process.sleep(1_000)
    assert 0 = HeartbeatTracker.count(tracker)
  end

  test "start_link/1 when missing params" do
    assert {:error, %ArgumentError{}} = Heartbeat.start_link([])
  end
end
