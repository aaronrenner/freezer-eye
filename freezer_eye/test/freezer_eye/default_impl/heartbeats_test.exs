defmodule FreezerEye.DefaultImpl.HeartbeatsTest do
  use ExUnit.Case

  alias FreezerEye.DefaultImpl.Heartbeats

  test "stop_default/0 can be called multiple times" do
    assert :ok = Heartbeats.stop_default()
    assert :ok = Heartbeats.stop_default()
  end
end
