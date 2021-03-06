defmodule FreezerEye.DefaultImpl.Supervisor do
  @moduledoc false
  use Supervisor

  alias FreezerEye.DefaultImpl.Heartbeats
  alias FreezerEye.DefaultImpl.Manager

  def start_link(opts) when is_list(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_init_opts) do
    children = [
      Heartbeats,
      Manager
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
