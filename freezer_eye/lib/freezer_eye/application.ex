defmodule FreezerEye.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import FreezerEye.Impl, only: [current_impl: 0]

  def start(_type, _args) do
    Code.ensure_loaded(current_impl())
    # List all child processes to be supervised
    children =
      if function_exported?(current_impl(), :child_spec, 1) do
        [current_impl()]
      else
        []
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FreezerEye.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
