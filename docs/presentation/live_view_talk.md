### Motivation

Phoenix LiveView is an exciting new way to build interactive, real-time web apps.

Traditionally, the only way to write web apps that are highly interactive has been by using JavaScript, along with the help of a library or framework such as React, Angular, or Vue. These technologies are very powerful, and developers can use them to create complex web applciations.

For some (many?) development teams, using a modern front-end UI framework introduces a lot of complexity. At Underbelly, JavaScript is kind of our Shtick, so the cost may not be as high as for others. Even so, I think most developers would agree that the JavaScript ecosystem can be a little crazy sometimes. It's a language that is evolving rapidly, and at the same time there's "supersets" like TypeScript, which adds types to the language. On top of that, we have to use tools like Babel to transpile our JavaScript into older JavaScript, or to turn our React components into actual JavaScript. In the end, these tools allow us to build sophisticated web apps, but that comes with a cost in complexity and maintainability.

Many of the web applications that I have worked on in the past have needed only a small level of interactivity. For example, validating form input fields, or creating multi-step forms to collect user input, etc. In most cases, we ended up accomplishing these sort of requirements by adding a full-fledged front-end library like React, and sprinkling it in where needed. In other words:

> There’s a common class of applications where rich experiences are needed, but full single-page applications are otherwise overkill to achieve the bits of required rich interaction.

Phoenix LiveView is not here to try and replace JavaScript, but it's an alternative way to create highly interactive web experiences without adding the complexity of a front-end UI library. LiveView uses JavaScript behind the scenes, but developers only need to write and test code using Elixir.

tldr; LiveView offers...

- Interactive, Real-Time apps without needing to write JavaScript
- A simple programming model
- Optimized application performance

### How LiveView Works

tldr; LiveView does what React does in terms of updating UI based on state changes, except it happens on the server.

1. Client makes HTTP request to the server.
2. Server returns a plain old HTML document to the client.

At this point, the user has a full page of server-rendered content.

3. Client upgrades to a websocket connection to enable real-time updates.

Once the websocket connection is established, the client may send updates to the server. Any updates to the state of the LiveView will trigger a UI render. Updates don't only have to come from the client. It's possible that other processes on the server can send messages to the LiveView process, which could result in a UI update.
