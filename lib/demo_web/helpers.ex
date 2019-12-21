defmodule DemoWeb.Helpers do
  def css(args) do
    args
    |> Enum.filter(fn {_class_name, condition} ->
      condition
    end)
    |> Keyword.keys()
    |> Enum.join(" ")
  end
end
