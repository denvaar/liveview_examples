# Tennis Scorekeeping

There's two parts to this example app. One page is for creating and updating pretend tennis matches. The other page allows users to subscribe and unsubscribe to the tennis matches. Score updates are shown in real-time. Let's explore how it all works.

### Tennis match admin page

The [admin page](/lib/demo_web/live/tennis_control_live.ex) is powered by a LiveView module. Looking at the render function, we can see that it shows a couple of input fields to collect each opponent's name, and a create button to start a new match. Matches are listed below all that, and the user can add points to each player.

[`Demo.Tennis.Matches`](/lib/demo/tennis/matches.ex) is a GenServer that helps me to share state between the admin page, and the user page. Looking at `Matches`'s client API we can see it can be used to create matches, list matches, increment the score of matches, and also subscribe to matches, as well as subscribe to the list of matches itself.

I'm using Phoenix pubsub to broadcast information about the matches, including the list of matches itself, along with the score for each match.

The scoring in tennis is kind of strange and unique, so I also created a separate module, [`Scoring`](/lib/demo/tennis/scoring.ex) to handle that logic.

### Tennis match subscriber page

The [subscriber page](/lib/demo_web/live/tennis_live.ex) is also powered by a LiveView module. This page is all about consuming the data created from the admin page. As matches are created on the admin page, the list of available matches to watch is updated in real-time, thanks to LiveView and pubsub. Users can choose to subscribe to one or more matches to view score updates in real time, also thanks to LiveView and pubsub.

```
def handle_event("subscribe-match", %{"match_id" => id}, socket) do
  match = Demo.Tennis.Matches.subscribe_to_match(id)

  {:noreply,
   assign(socket,
     match_subscriptions: [match | socket.assigns.match_subscriptions]
   )}
end
```

The code snippet above is what gets executed when a user clicks the "subscribe" button. `Demo.Tennis.Matches.subscribe_to_match(id)` is a call to the `Matches` GenServer, which subscribes the LiveView process to any score updates that might happen for the given match. That means whenever a point is added, a `"score-updated"` event is sent to the LiveView process. The event is handled with `handle_event/3`:

```
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
```
