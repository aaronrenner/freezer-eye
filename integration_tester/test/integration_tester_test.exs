defmodule IntegrationTesterTest do
  use IntegrationTester.BypassCase

  import Plug.Conn

  alias FETestHelpers.HeartbeatTracker

  @moduletag :capture_log

  setup [
    :configure_heartbeat_tracker
  ]

  @tag :bypass
  @tag :heartbeat_tracker
  test "sends a heartbeat every x milliseconds", %{bypass: bypass, heartbeat_tracker: tracker} do
    interval = 200

    configure_application(
      heartbeat_interval: interval,
      base_url: bypass_url(bypass)
    )

    FreezerEye.enable_heartbeat()

    Process.sleep(interval * 5)

    FreezerEye.disable_heartbeat()

    assert_in_delta 5, HeartbeatTracker.count(tracker), 1
    assert_heartbeat_intervals(tracker, interval)
  end

  @tag :bypass
  @tag :heartbeat_tracker
  test "continues sending after network is disconnected", %{
    bypass: bypass,
    heartbeat_tracker: tracker
  } do
    configure_application(
      heartbeat_interval: 200,
      base_url: bypass_url(bypass)
    )

    Bypass.down(bypass)

    FreezerEye.enable_heartbeat()

    Process.sleep(400)

    Bypass.up(bypass)

    Process.sleep(600)

    FreezerEye.disable_heartbeat()

    assert_in_delta 3, HeartbeatTracker.count(tracker), 1
    assert_heartbeat_intervals(tracker, 200)
  end

  @tag :bypass
  @tag :heartbeat_tracker
  test "stops sending when heartbeat is disabled", %{bypass: bypass, heartbeat_tracker: tracker} do
    interval = 200

    configure_application(
      heartbeat_interval: interval,
      base_url: bypass_url(bypass)
    )

    FreezerEye.enable_heartbeat()
    Process.sleep(interval * 2)
    FreezerEye.disable_heartbeat()

    count_when_finished = HeartbeatTracker.count(tracker)
    assert_in_delta 2, count_when_finished, 1

    Process.sleep(interval * 5)

    assert HeartbeatTracker.count(tracker) == count_when_finished
  end

  @tag :bypass
  @tag :heartbeat_tracker
  test "doesn't affect intervals if you try to start multiple times", %{
    bypass: bypass,
    heartbeat_tracker: tracker
  } do
    configure_application(
      heartbeat_interval: 200,
      base_url: bypass_url(bypass)
    )

    FreezerEye.enable_heartbeat()
    FreezerEye.enable_heartbeat()
    Process.sleep(1000)
    FreezerEye.disable_heartbeat()

    count_when_finished = HeartbeatTracker.count(tracker)

    Process.sleep(1000)

    assert HeartbeatTracker.count(tracker) == count_when_finished
  end

  test "disable_heartbeat doesn't error if it's not started" do
    assert :ok = FreezerEye.disable_heartbeat()
    assert :ok = FreezerEye.disable_heartbeat()
  end

  defp configure_heartbeat_tracker(%{bypass: %Bypass{} = bypass, heartbeat_tracker: true}) do
    {:ok, heartbeat_tracker} = HeartbeatTracker.start_link([])
    username = "foo"
    heartbeat_name = "test-feed"

    expected_path = Enum.join(["", "api", "v2", username, "feeds", heartbeat_name, "data"], "/")

    Bypass.stub(bypass, "POST", expected_path, fn conn ->
      HeartbeatTracker.record_heartbeat(heartbeat_tracker)

      conn
      |> send_resp(200, "")
    end)

    {:ok, heartbeat_tracker: heartbeat_tracker}
  end

  defp configure_heartbeat_tracker(_), do: :ok

  defp bypass_url(%Bypass{port: port}) do
    "http://localhost:#{port}"
  end

  defp configure_application(opts) when is_list(opts) do
    interval = Keyword.get(opts, :heartbeat_interval, 200)
    base_url = Keyword.fetch!(opts, :base_url)

    Application.put_env(:fe_reporting, :adafruit_io,
      username: "foo",
      secret_key: "secret",
      heartbeat_feed: "test-feed",
      heartbeat_value: 1,
      base_url: base_url
    )

    Application.put_env(:freezer_eye, :heartbeat_interval, interval)
  end

  defp assert_heartbeat_intervals(tracker, interval) do
    intervals =
      tracker
      |> HeartbeatTracker.list_heartbeat_intervals(:millisecond)
      # Skip the first interval because bypass takes a few hundred
      # milliseconds to handle the first request
      |> tl()

    for actual_interval <- intervals do
      assert_in_delta interval, actual_interval, 25
    end
  end
end
