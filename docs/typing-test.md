# Typing Test Example

As we've seen in the previous examples, LiveView makes it easy to create real-time user experiences. All of the examples so far have shown what LiveView is capable of pretty much on its own. There's actually more cool features of the Phoenix Web Framework, as well as Elixir, that can be used to make apps that have an even higher level of real-time functionality.

This [typing test example](/lib/demo_web/live/typing_test_live.ex) shows how Elixir processes can be used to keep state ([GenServer](https://hexdocs.pm/elixir/GenServer.html)), and also how to utilize Phoenix channels/pub-sub in order to broadcast real-time changes to multiple clients at a time.

There's three different modules being used with this example.

1. `Demo.TypingTest.Parse` is responsible for creating HTML markup (either green or red) based on the prompt for the typing test, and the user input.
2. `Demo.TypingTest.Stats` has an API that handles the calculation of WPM. `Stats` is more than just an Elixir module, it's a specialized Elixir process, called `GenServer` (generic server process). `GenServer`s provide a clean and consistent API for interacting with state.

_Side note: If Elixir is just functions, how can you create state? TODO_

3. `Demo.TypingTest.History` is another type of specialized process, called an `Agent`. An `Agent` another, more simplified way to interact with state and share it across processes. The responsibility of the `History` module is to have a place to typing test results for all users. It's kind of acting like database that is reset whenever the system is restarted. We're able to grab the list of recently completed typing tests for all users, and update the UI when the LiveView is initially mounting.

### Managing state

It's true that state can be managed as part of LiveView directly by assigning things to the socket, which is how things were handled in previous examples. There are other ways of interacting with state that Elixir has to offer.

If state can be stored and managed by interacting with a socket, then why would we ever want to put it somewhere else? One reason might be because the LiveView module doesn't actually need to know about certain parts of state. The way that I understand it, state that is assigned to the socket should generally come into play somehow in the view or template.

### Phoenix Pubsub

Another part of this example that is new is it's ability to broadcast, or publish events across the entire system. This is done using [Phoenix pubsub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html). Whenever a browser connects to the LiveView, that process is subscribed to the `"typing_test_results"` topic. Whenever someone finishes a typing test, that event is broadcast to all of the subscribed processes in the system. The user interface is updated accordingly by listing typing test results toward the bottom of the page.
