defmodule DemoWeb.TennisView do
  use DemoWeb, :view

  def is_subscribed?(subscribed_matches, id) do
    subscribed_matches
    |> Enum.find_index(fn m ->
      m.id == id
    end) != nil
  end
end
