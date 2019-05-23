defmodule FreezerEye.DefaultImpl.Heartbeats.Heartbeat do
  @moduledoc false
  use Supervisor

  alias __MODULE__.Server

  @type start_link_opt ::
          {:interval, timeout()}
          | {:heartbeat_fn, (() -> term)}
          | Supervisor.option()

  @spec start_link([start_link_opt]) :: Supervisor.on_start()
  def start_link(opts) do
    {start_opts, init_opts} = Keyword.split(opts, [:name])

    with {:ok, interval} <- fetch_required_opt(init_opts, :interval),
         {:ok, heartbeat_fn} <- fetch_required_opt(init_opts, :heartbeat_fn) do
      Supervisor.start_link(
        __MODULE__,
        %{interval: interval, heartbeat_fn: heartbeat_fn},
        start_opts
      )
    else
      {:error, error} ->
        {:error, error}
    end
  end

  @spec stop(Supervisor.supervisor()) :: :ok
  def stop(pid) do
    Supervisor.stop(pid)
  end

  @impl true
  def init(%{interval: interval, heartbeat_fn: heartbeat_fn}) do
    children = [
      {Server, [supervisor: self(), interval: interval, heartbeat_fn: heartbeat_fn]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @spec fetch_required_opt([start_link_opt], atom) :: {:ok, term} | {:error, term}
  defp fetch_required_opt(opts, key) do
    case Keyword.fetch(opts, key) do
      {:ok, value} ->
        {:ok, value}

      :error ->
        {:error, ArgumentError.exception(message: "missing required argument #{inspect(key)}")}
    end
  end
end
