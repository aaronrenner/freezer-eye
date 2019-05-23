defmodule FreezerEye.DefaultImpl.Heartbeats.Heartbeat.Server do
  @moduledoc false
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(init_opts) do
    with {:ok, interval} <- fetch_required_opt(init_opts, :interval),
         {:ok, heartbeat_fn} <- fetch_required_opt(init_opts, :heartbeat_fn),
         {:ok, supervisor} <- fetch_required_opt(init_opts, :supervisor) do
      state = %{interval: interval, heartbeat_fn: heartbeat_fn, supervisor: supervisor}
      {:ok, state, {:continue, :start}}
    else
      {:error, error} ->
        {:stop, error}
    end
  end

  @impl true
  def handle_continue(
        :start,
        %{supervisor: supervisor, heartbeat_fn: heartbeat_fn, interval: interval} = state
      ) do
    {:ok, task_supervisor} =
      Supervisor.start_child(
        supervisor,
        Supervisor.child_spec(Task.Supervisor, restart: :temporary)
      )

    state = Map.put(state, :task_supervisor, task_supervisor)

    Task.Supervisor.start_child(task_supervisor, heartbeat_fn)
    Process.send_after(self(), :send_heartbeat, interval)

    {:noreply, state}
  end

  @impl true
  def handle_info(
        :send_heartbeat,
        %{task_supervisor: task_supervisor, heartbeat_fn: heartbeat_fn, interval: interval} =
          state
      ) do
    Task.Supervisor.start_child(task_supervisor, heartbeat_fn)
    Process.send_after(self(), :send_heartbeat, interval)

    {:noreply, state}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  defp fetch_required_opt(opts, key) do
    case Keyword.fetch(opts, key) do
      {:ok, value} ->
        {:ok, value}

      :error ->
        {:error, ArgumentError.exception(message: "missing required argument #{inspect(key)}")}
    end
  end
end
