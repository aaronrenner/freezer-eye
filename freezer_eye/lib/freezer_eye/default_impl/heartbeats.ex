defmodule FreezerEye.DefaultImpl.Heartbeats do
  @moduledoc false

  alias FreezerEye.DefaultImpl.Heartbeats.Heartbeat

  @spec start_default :: :ok
  def start_default do
    case Heartbeat.start_link(
           interval: 200,
           heartbeat_fn: &FEReporting.send_heartbeat/0,
           name: DefaultHeartbeat
         ) do
      {:ok, _pid} ->
        :ok

      {:error, {:already_started, _pid}} ->
        :ok
    end
  end

  @spec stop_default :: :ok
  def stop_default do
    Heartbeat.stop(DefaultHeartbeat)
  end
end
