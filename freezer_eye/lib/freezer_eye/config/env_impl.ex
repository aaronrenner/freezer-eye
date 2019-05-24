defmodule FreezerEye.Config.EnvImpl do
  @moduledoc false

  alias FreezerEye.Config

  @behaviour FreezerEye.Config.Impl

  @impl true
  @spec fetch!() :: Config.t() | none
  def fetch! do
    %Config{
      heartbeat_interval: Application.fetch_env!(:freezer_eye, :heartbeat_interval),
      enable_heartbeat_on_startup?:
        Application.get_env(:freezer_eye, :enable_heartbeat_on_startup, true)
    }
  end
end
