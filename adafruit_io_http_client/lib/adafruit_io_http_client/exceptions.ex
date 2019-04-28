defmodule AdafruitIOHTTPClient.HTTPClientError do
  @moduledoc """
  Indicates the request was unable to be completed due to a low level
  HTTP client error.
  """
  defexception [:message, :reason]

  @type t :: %__MODULE__{
          message: String.t(),
          reason: atom
        }

  def exception(opts) when is_list(opts) do
    reason = Keyword.fetch!(opts, :reason)
    message = "unable to complete HTTP request: #{inspect(reason)}"

    %__MODULE__{reason: reason, message: message}
  end
end

defmodule AdafruitIOHTTPClient.UnexpectedResponseFormatError do
  @moduledoc """
  Indicates the response we received was in an unexpected format
  """

  defexception [:message, :response_body]

  @type t :: %__MODULE__{
          message: String.t(),
          response_body: term
        }

  def exception(opts) when is_list(opts) do
    response_body = Keyword.fetch!(opts, :response_body)

    message = "unexpected format for api response"

    %__MODULE__{response_body: response_body, message: message}
  end
end

defmodule AdafruitIOHTTPClient.UnexpectedStatusCodeError do
  @moduledoc """
  Indicates we received a response with an unexpected HTTP
  status code from Adafruit's API.
  """

  defexception [:message, :status_code, :response_body]

  @type t :: %__MODULE__{
          message: String.t(),
          status_code: 100..599,
          response_body: String.t()
        }

  def exception(opts) when is_list(opts) do
    status_code = Keyword.fetch!(opts, :status_code)
    response_body = Keyword.fetch!(opts, :response_body)

    message = """
    unexpected response from the https://io.adafruit.com API
    status_code: #{status_code}"
    response_body: #{inspect(response_body)}"
    """

    %__MODULE__{
      status_code: status_code,
      response_body: response_body,
      message: message
    }
  end
end
