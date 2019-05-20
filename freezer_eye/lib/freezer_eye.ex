defmodule FreezerEye do
  @moduledoc """
  Primary API for FreezerEye app
  """

  alias FreezerEye.DefaultImpl

  @behaviour FreezerEye.Impl

  @doc """
  Manually send a heartbeat message to the reporting service
  """
  def send_heartbeat do
    :ok
  end

  @doc """
  Enables periodic sending of heartbeat message to the reporting service
  """
  @impl true
  @spec enable_heartbeat :: :ok
  def enable_heartbeat do
    impl().enable_heartbeat()
  end

  @doc """
  Disables periodic sending of heartbeat message to the reporting service
  """
  @impl true
  @spec disable_heartbeat :: :ok
  def disable_heartbeat do
    impl().disable_heartbeat()
  end

  defp impl do
    Application.get_env(:freezer_eye, :impl, DefaultImpl)
  end
end
