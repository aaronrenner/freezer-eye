defmodule FEReporting.AdafruitIOHTTPImpl.Config do
  @moduledoc false

  alias __MODULE__.EnvImpl

  @behaviour __MODULE__.Impl

  defstruct [:username, :secret_key, :heartbeat_feed, :heartbeat_value]

  @type t :: %__MODULE__{
          username: String.t(),
          secret_key: String.t(),
          heartbeat_feed: String.t(),
          heartbeat_value: integer
        }

  @impl true
  @spec fetch!() :: t | none
  def fetch! do
    impl().fetch!()
  end

  defp impl do
    Application.get_env(:fe_reporting, :adafruit_io_config_impl, EnvImpl)
  end
end
