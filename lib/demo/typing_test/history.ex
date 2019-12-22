defmodule Demo.TypingTest.History do
  use Agent

  def start_link(initial_state \\ []) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def log(id, wpm) do
    Agent.update(__MODULE__, fn logs ->
      [%{id: id, wpm: wpm} | logs]
    end)
  end

  def get_recent_tests() do
    Agent.get(__MODULE__, & &1)
  end
end
