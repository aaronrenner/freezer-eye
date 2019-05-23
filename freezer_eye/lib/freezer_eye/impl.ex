defmodule FreezerEye.Impl do
  @moduledoc false

  alias FreezerEye.DefaultImpl

  @callback enable_heartbeat :: :ok

  @callback disable_heartbeat :: :ok

  def current_impl do
    Application.get_env(:freezer_eye, :impl, DefaultImpl)
  end
end
