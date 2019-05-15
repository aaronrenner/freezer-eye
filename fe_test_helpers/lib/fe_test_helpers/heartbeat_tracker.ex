defmodule FETestHelpers.HeartbeatTracker do
  @moduledoc """
  Heartbeat tracking helper
  """

  alias __MODULE__.Impl

  @type start_link_opt :: GenServer.option()
  @type tracker :: pid()

  @spec start_link([start_link_opt]) :: GenServer.on_start()
  def start_link(_opts) do
    Agent.start_link(fn -> Impl.new() end)
  end

  @spec record_heartbeat(tracker) :: :ok
  def record_heartbeat(pid) do
    Agent.update(pid, fn impl ->
      Impl.record_heartbeat(impl)
    end)
  end

  @spec list_heartbeat_timestamps(tracker) :: [DateTime.t()]
  def list_heartbeat_timestamps(pid) do
    pid
    |> Agent.get(& &1)
    |> Impl.list_heartbeat_timestamps()
  end

  @spec list_heartbeat_intervals(tracker, System.time_unit()) :: [integer]
  def list_heartbeat_intervals(pid, time_unit \\ :second) do
    pid
    |> Agent.get(& &1)
    |> Impl.list_heartbeat_intervals(time_unit)
  end
end
