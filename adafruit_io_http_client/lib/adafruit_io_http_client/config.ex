defmodule AdafruitIOHTTPClient.Config do
  @moduledoc """
  Configuration to use for the API client
  """

  @type username :: String.t()
  @type secret_key :: String.t()
  @type base_url :: String.t()

  @type t :: %__MODULE__{
          base_url: base_url,
          username: username,
          secret_key: secret_key
        }

  defstruct [:base_url, :username, :secret_key]

  @default_base_url "https://io.adafruit.com"

  @type new_opt :: {:base_url, base_url}

  @doc """
  Creates a new config with the default options set
  """
  @spec new(username, secret_key, [new_opt]) :: t
  def new(username, secret_key, opts \\ [])
      when is_binary(username) and is_binary(secret_key) and is_list(opts) do
    %__MODULE__{
      username: username,
      secret_key: secret_key,
      base_url: Keyword.get(opts, :base_url, @default_base_url)
    }
  end

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
