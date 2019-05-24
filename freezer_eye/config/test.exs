use Mix.Config

config :freezer_eye,
  enable_heartbeat_on_startup: true

config :fe_reporting, :adafruit_io,
  username: "foo",
  secret_key: "bar",
  heartbeat_feed: "test-feed"
