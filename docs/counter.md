# Counter Example

This example is a counter, and it's pretty self explanatory. The user can click a plus and minus button to increment and decrement the value. The value is bounded between 0 and 10. There's a progress bar to indicate the value as well, and it has a CSS transition applied to it so that it moves smoothly as the value changes.

The code for this LiveView is [here](/lib/demo_web/live/counter_live.ex). `use Phoenix.LiveView` is used to inject code into the `CounterLive` module, which is required for things to work. `CounterLive` also has three functions: `mount/2`, `render/1`, and `handle_event/3`. Let's go what each one does.

### Meet `mount/2`

Mount is the first function that happens. We need a place to store the value of the counter so that LiveView can perform change tracking. State is stored on the socket using `assign/2`. So, in this example the app starts with an initial value of 0, and that's all the state that's required for this app.

### Introducing `render/1`

The job of this function is to render HTML for the browser. The idea is that you write HTML markup and Elixir functions inside of `~L"""..."""` so that LiveView's template engine can turn it into an HTML document. Notice that render takes an `assigns` parameter. This is what gives you acess to things that you've `assign`-ed to the socket. `<%= if @count ...` is an example of this, since I have assigned `count` to the socket (Note: `@count` is the same as writing `assigns.socket.count`.)

To summarize what's happening in this function, I am using the `count` value to conditionally render the UI differently. I'm also changing style of a `span` element by calclating a percentage.

### Encounter `handle_event/3`

LiveView's receive messages based on certain events that happen. In this example, `handle_event` exists to respond to the `"change-count"` message. You may have noticed some `phx-click="change-count"`'s in the render function.

```
<button
  class="button is-info"
  phx-click="change-count"
  value="1">
+
</button>
```

That's so that whenever the button is clicked, a message is sent to the LiveView with a value of "1" or "-1". A new `count` value is computed and re-assigned to the socket. This will trigger the render function to execute, which updates the UI in response to the event.
