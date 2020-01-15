# Colors Example

This is more of an example of what you probably should not do with LiveView. At the same time, it's impressive how well this example performs. In this example, 1,000 "bubbles" are created with a random color and position on the page. After one second, a process runs every 16 milliseconds to update each bubble's position on the page. As time goes on, the bubbles are grouped together on the page from left to right according to their hue.

This example performs pretty well when there's 1,000 bubbles, and when the updates happen every 16 milliseconds, but if you increase the bubbles, things will begin to be noticabley laggy. That's because each `:tick` event is updating every single bubble, and sending all of the updated bubble data to the browser. That's a lot of data over the wire. In fact, according to my browser, this example app sends 33,548 bytes of data every 16 milliseconds until all of the colors are grouped by hue.

So, because this example requires large amounts of data sent over the wire in real-time, this is probably better off as a client-side application so that latency is not an issue.
