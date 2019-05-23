defmodule FreezerEye do
  @moduledoc """
  Primary API for FreezerEye app
  """

  import FreezerEye.Impl, only: [current_impl: 0]

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
    current_impl().enable_heartbeat()
  end

  @doc """
  Disables periodic sending of heartbeat message to the reporting service
  """
  @impl true
  @spec disable_heartbeat :: :ok
  def disable_heartbeat do
    current_impl().disable_heartbeat()
  end
end
