defmodule Demo.TypingTest.Stats do
  use GenServer

  def start_link(process_name) do
    GenServer.start_link(__MODULE__, initial_state(), name: process_name)
  end

  def update_wpm(pid, input) do
    GenServer.call(pid, {:update_wpm, input})
  end

  def get_stats(pid) do
    GenServer.call(pid, :get_stats)
  end

  def reset(pid), do: GenServer.cast(pid, :reset)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:reset, _state) do
    {:noreply, %{initial_state() | start_time: DateTime.utc_now()}}
  end

  @impl true
  def handle_call({:update_wpm, input}, _from, state) do
    time_diff =
      DateTime.utc_now()
      |> DateTime.diff(state.start_time)

    new_state = %{
      state
      | wpm: calculate_wpm(input, time_diff),
        elapsed_time: time_diff
    }

    {:reply, client_data(new_state), new_state}
  end

  def handle_call(:get_stats, _from, state) do
    {:reply, client_data(state), state}
  end

  defp calculate_wpm(_input, 0), do: 0

  defp calculate_wpm(input, time_diff) do
    input
    |> count_words()
    |> Kernel./(time_diff / 60)
    |> Kernel.round()
    |> Kernel.trunc()
  end

  defp initial_state() do
    %{
      elapsed_time: 0,
      start_time: 0,
      wpm: 0
    }
  end

  defp client_data(state), do: Map.take(state, [:wpm, :elapsed_time])

  defp count_words(input) do
    input
    |> String.split()
    |> Enum.count()
  end
end
