defmodule FreezerEye.Config.Impl do
  @moduledoc false

  alias FreezerEye.Config

  @callback fetch!() :: Config.t() | none
end
