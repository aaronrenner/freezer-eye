defmodule FETestHelpers.HeartbeatTracker.Impl do
  @moduledoc false

  @opaque t :: [DateTime.t()]

  defguardp is_impl(data) when is_list(data)

  @spec new :: t
  def new, do: []

  @spec record_heartbeat(t, DateTime.t()) :: t
  def record_heartbeat(reversed_heartbeats, timestamp = %DateTime{} \\ DateTime.utc_now())
      when is_impl(reversed_heartbeats) do
    [timestamp | reversed_heartbeats]
  end

  @spec list_heartbeat_timestamps(t) :: [DateTime.t()]
  def list_heartbeat_timestamps(reversed_heartbeats) when is_impl(reversed_heartbeats) do
    Enum.reverse(reversed_heartbeats)
  end

  @spec list_heartbeat_intervals(t, System.time_unit()) :: [integer]
  def list_heartbeat_intervals(reversed_heartbeats, time_unit \\ :second) do
    reversed_heartbeats
    |> Enum.reverse()
    |> do_list_heartbeat_intervals(time_unit)
  end

  defp do_list_heartbeat_intervals(
         [%DateTime{} = current | [%DateTime{} = next | _] = rest],
         time_unit
       ) do
    [DateTime.diff(next, current, time_unit) | do_list_heartbeat_intervals(rest, time_unit)]
  end

  defp do_list_heartbeat_intervals([%DateTime{} | []], _), do: []
  defp do_list_heartbeat_intervals([], _), do: []
end
