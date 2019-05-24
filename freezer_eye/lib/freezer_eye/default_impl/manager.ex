defmodule FreezerEye.DefaultImpl.Manager do
  @moduledoc false
  use GenServer

  alias FreezerEye.Config
  alias FreezerEye.DefaultImpl.Heartbeats

  def start_link(opts) when is_list(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(_init_opts) do
    {:ok, [], {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, state) do
    %Config{enable_heartbeat_on_startup?: enable_heartbeat_on_startup?} = Config.fetch!()

    if enable_heartbeat_on_startup? do
      Heartbeats.start_default()
    end

    {:noreply, state}
  end
end
