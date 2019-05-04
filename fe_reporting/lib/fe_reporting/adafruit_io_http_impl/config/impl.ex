defmodule FEReporting.AdafruitIOHTTPImpl.Config.Impl do
  @moduledoc false

  alias FEReporting.AdafruitIOHTTPImpl.Config

  @callback fetch!() :: Config.t() | none
end
