# FEReporting

Internal reporting API for FreezerEye.

## Configuration

Configuration settings can be stored in the environment like this:

```elixir
config :fe_reporting, :adafruit_io,
  username: "set me",
  secret_key: "set me",
  heartbeat_feed: "set me",
  heartbeat_value: 1
```
