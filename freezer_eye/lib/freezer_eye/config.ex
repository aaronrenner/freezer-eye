defmodule FreezerEye.Config do
  @moduledoc false

  alias __MODULE__.EnvImpl

  @behaviour __MODULE__.Impl

  defstruct [:heartbeat_interval]

  @type t :: %__MODULE__{
          heartbeat_interval: pos_integer()
        }

  @impl true
  @spec fetch!() :: t | none
  def fetch! do
    impl().fetch!()
  end

  defp impl do
    Application.get_env(:freezer_eye, :config_impl, EnvImpl)
  end
end
