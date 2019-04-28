defmodule AdafruitIOHTTPClient.Config do
  @moduledoc """
  Configuration to use for the API client
  """

  @type t :: %__MODULE__{
          base_url: String.t(),
          username: String.t(),
          secret_key: String.t()
        }

  defstruct [:base_url, :username, :secret_key]

  @doc """
  Loads the config out of the `:adafruit_io_http_client` namespace in the
  environment.
  """
  @spec load_from_env! :: t | no_return
  def load_from_env! do
    %__MODULE__{
      base_url: Application.fetch_env!(:adafruit_io_http_client, :base_url),
      username: Application.fetch_env!(:adafruit_io_http_client, :username),
      secret_key: Application.fetch_env!(:adafruit_io_http_client, :secret_key)
    }
  end
end
