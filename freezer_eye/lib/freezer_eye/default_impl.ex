defmodule FreezerEye.DefaultImpl do
  @moduledoc false

  alias FreezerEye.DefaultImpl.Heartbeats

  @behaviour FreezerEye.Impl

  @impl true
  @spec enable_heartbeat :: :ok
  def enable_heartbeat do
    Heartbeats.start_default()
    :ok
  end

  @impl true
  @spec disable_heartbeat :: :ok
  def disable_heartbeat do
    Heartbeats.stop_default()
    :ok
  end

  @doc false
  defdelegate child_spec(arg), to: __MODULE__.Supervisor
end
