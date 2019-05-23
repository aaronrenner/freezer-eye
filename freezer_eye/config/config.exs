# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :freezer_eye,
  heartbeat_interval: 60_000

config :fe_reporting, :adafruit_io, heartbeat_value: 1

import_config "#{Mix.env()}.exs"

# Support optional <ENV>.secret.exs files
try do
  import_config "#{Mix.env()}.secret.exs"
rescue
  Code.LoadError -> :ok
end
