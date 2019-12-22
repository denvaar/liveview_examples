defmodule DemoWeb.TypingTestView do
  use DemoWeb, :view

  def mins(elapsed_time) do
    elapsed_time
    |> Kernel./(60)
    |> format()
  end

  def sec(elapsed_time) do
    elapsed_time
    |> format()
  end

  defp format(time) do
    time
    |> floor()
    |> rem(60)
    |> Integer.to_string()
    |> String.pad_leading(2, "00")
  end
end
