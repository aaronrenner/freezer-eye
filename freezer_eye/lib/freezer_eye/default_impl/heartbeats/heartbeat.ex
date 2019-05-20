defmodule FreezerEye.DefaultImpl.Heartbeats.Heartbeat do
  @moduledoc false
  use GenServer

  @type start_link_opt ::
          {:interval, timeout()}
          | {:heartbeat_fn, (() -> term)}
          | GenServer.option()

  @spec start_link([start_link_opt]) :: GenServer.on_start()
  def start_link(opts) do
    {start_opts, init_opts} = Keyword.split(opts, [:name])
    GenServer.start_link(__MODULE__, init_opts, start_opts)
  end

  @spec stop(GenServer.server()) :: :ok
  def stop(pid) do
    GenServer.stop(pid)
  end

  @impl true
  def init(init_opts) do
    with {:ok, interval} <- fetch_required_opt(init_opts, :interval),
         {:ok, heartbeat_fn} <- fetch_required_opt(init_opts, :heartbeat_fn) do
      {:ok, %{interval: interval, heartbeat_fn: heartbeat_fn}, {:continue, :start}}
    else
      {:error, error} ->
        {:stop, error}
    end
  end

  @impl true
  def handle_continue(:start, %{interval: interval, heartbeat_fn: heartbeat_fn} = state) do
    Task.start(heartbeat_fn)
    Process.send_after(self(), :send_heartbeat, interval)

    {:noreply, state}
  end

  @impl true
  def handle_info(:send_heartbeat, %{interval: interval, heartbeat_fn: heartbeat_fn} = state) do
    Task.start(heartbeat_fn)
    Process.send_after(self(), :send_heartbeat, interval)

    {:noreply, state}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  @spec fetch_required_opt([start_link_opt], atom) :: {:ok, term} | ArgumentError.t()
  defp fetch_required_opt(opts, key) do
    case Keyword.fetch(opts, key) do
      {:ok, value} ->
        {:ok, value}

      :error ->
        {:error, ArgumentError.exception(message: "missing required argument #{inspect(key)}")}
    end
  end
end
