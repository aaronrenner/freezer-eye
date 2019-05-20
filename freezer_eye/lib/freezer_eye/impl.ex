defmodule FreezerEye.Impl do
  @moduledoc false

  @callback enable_heartbeat :: :ok

  @callback disable_heartbeat :: :ok
end
