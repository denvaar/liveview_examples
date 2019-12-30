defmodule DemoWeb.TennisLive do
  use Phoenix.LiveView

  def mount(_session, socket) do
    if connected?(socket), do: Demo.Tennis.Matches.subscribe_to_match_list()

    {:ok,
     assign(socket,
       match_subscriptions: [],
       all_matches: Demo.Tennis.Matches.get_matches()
     )}
  end

  def render(assigns) do
    Phoenix.View.render(DemoWeb.TennisView, "index.html", assigns)
  end

  def handle_event("subscribe-match", %{"match_id" => id}, socket) do
    match = Demo.Tennis.Matches.subscribe_to_match(id)

    {:noreply,
     assign(socket,
       match_subscriptions: [match | socket.assigns.match_subscriptions]
     )}
  end

  def handle_event("unsubscribe-match", %{"match_id" => id}, socket) do
    Demo.Tennis.Matches.unsubscribe_from_match(id)

    match_subscriptions =
      socket.assigns.match_subscriptions
      |> Enum.filter(fn m -> m.id != id end)

    {:noreply,
     assign(socket,
       match_subscriptions: match_subscriptions
     )}
  end

  def handle_info(%{event: "match_added", payload: %{matches: matches}}, socket) do
    {:noreply, assign(socket, all_matches: matches)}
  end

  def handle_info(%{event: "score_updated", payload: %{match: match}}, socket) do
    index =
      socket.assigns.match_subscriptions
      |> Enum.find_index(fn %{id: id} ->
        id == match.id
      end)

    match_subscriptions =
      socket.assigns.match_subscriptions
      |> List.update_at(index, fn _ -> match end)

    {:noreply, assign(socket, match_subscriptions: match_subscriptions)}
  end
end
