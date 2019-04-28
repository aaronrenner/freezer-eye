defmodule AdafruitIOHTTPClient.Datapoint do
  @moduledoc """
  A recorded datapoint
  """

  @type id :: String.t()
  @type value :: integer
  @type t :: %__MODULE__{
          id: id,
          value: value
        }

  defstruct [:id, :value]
end
