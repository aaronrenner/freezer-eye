defmodule FEReporting do
  @moduledoc """
  Internal API for FreezerEye's reporting logic.
  """

  alias FEReporting.AdafruitIOHTTPImpl

  @behaviour FEReporting.Impl

  @doc """
  Sends a heartbeat to the reporting service
  """
  @impl true
  @spec send_heartbeat :: :ok
  def send_heartbeat do
    impl().send_heartbeat()
  end

  defp impl do
    Application.get_env(:fe_reporting, :impl, AdafruitIOHTTPImpl)
  end
end
