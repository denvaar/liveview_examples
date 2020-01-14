# Form Validation Example

This example has a couple more things going on, but it still uses the same concepts and functions as mentioned in the [counter example](./counter.md). One great use case for LiveView is real-time form validation.

In this example there are three input fields: Name, email and date. Each has their own rules for what kind of input is considered valid.

I've added `name`, `email`, and `date` to the socket assigns, so that the app can perform validation against the values. I'll come back to explain what `js_enabled` is for in a minute.

This example also shows how it's possible to delegate rendering the markup to a separate view module and leex template file. In the [view module](./lib/demo_web/views/form_validation_view.ex), I've created a few different functions that have to do with conditionally rendering markup, and formatting messages.

Here's an excerpt of code from the template. `phx_change` is added to the form element. An "input-change" event will be triggered every time an input field changes.

```
<%= form_for DemoWeb.Endpoint, Routes.process_form_path(DemoWeb.Endpoint, :post), [phx_change: "input-change", phx_submit: "submit"], fn _f -> %>

   ...

    <input
       name="<%= @name %>"
       phx-debounce="700"
       class="input <%= @css_classes %>"
       type="<%= @input_type %>"
       placeholder="<%= @placeholder %>"
       value="<%= @value %>">

    ...
```

I've created some event handler functions (`handle_event("input-change" ...`) to define what happens after one of the input fields change, as well as when a form is submitted.

Rather than having one event handler function with conditionals to determine which field is changing, [pattern matching](https://elixir-lang.org/getting-started/pattern-matching.html) can be used in the function heads.

### JavaScript Disabled

One cool thing about LiveView, and this example in particular, is that you can write your app in a way that provides the best user experience possible regardless of whether their JavaScript is disabled or not.

For someone with JavaScript enabled, the "best" user experience is to have real-time field validations. However, if for some reason someone has JavaScript disabled, then the form should still be usable, and it can instead perform the validations upon form submission.

It turns out there's not many code changes needed to satisfy both of these use cases. First, in `mount` I added `js_enabled: connected?(socket)` to be able to tell if the browser had JavaScript enabled. How is it possible to tell? It's because `mount` is actually called twice: first on the initial request, and once more when a websocket connection is established. `connected?/1` returns true when the websocket connection was successfully established, and false otherwise.

The second thing I had to do in order to accomodate JavaScript disabled browsers was to make sure the HTML form had a route to a controller as the form action param, which can be found [here](lib/demo_web/controllers/form_validation_controller.ex). If the form fields are not all valid when the form is submitted, then the user is redirected back to the form. That's where the `handle_params` function comes into play. When the LiveView is requested with "name", "email", and "date" query parameters, then the values are assigned into the socket. The error message is also rendered to the page at that point.
