defmodule FreezerEye.DefaultImpl.Heartbeats do
  @moduledoc false

  alias __MODULE__.Heartbeat
  alias __MODULE__.DefaultHeartbeat
  alias __MODULE__.Supervisor, as: HeartbeatsSupervisor
  # FIXME: this is a circular dependency and the interval should be passed in
  alias FreezerEye.Config

  @spec start_default :: :ok
  def start_default do
    %Config{heartbeat_interval: heartbeat_interval} = Config.fetch!()

    HeartbeatsSupervisor
    |> Supervisor.start_child(
      Supervisor.child_spec(
        {
          Heartbeat,
          heartbeat_fn: &FEReporting.send_heartbeat/0,
          interval: heartbeat_interval,
          name: DefaultHeartbeat
        },
        restart: :temporary
      )
    )
    |> case do
      {:ok, _pid} ->
        :ok

      {:error, {:already_started, _pid}} ->
        :ok
    end
  end

  @spec stop_default :: :ok
  def stop_default do
    case Process.whereis(DefaultHeartbeat) do
      pid when is_pid(pid) ->
        Heartbeat.stop(pid)

      _ ->
        :ok
    end
  end

  defdelegate child_spec(opt), to: __MODULE__.Supervisor
end
