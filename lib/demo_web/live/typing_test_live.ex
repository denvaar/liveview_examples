defmodule DemoWeb.TypingTestLive do
  use Phoenix.LiveView
  alias Demo.TypingTest.{Parse, Stats, History}

  def mount(_session, socket) do
    input = ""

    if connected?(socket), do: DemoWeb.Endpoint.subscribe("typing_test_results")

    {:ok,
     assign(socket,
       status: "waiting",
       prompt: get_prompt(input),
       wpm: 0,
       elapsed_time: 0,
       input: input,
       history: History.get_recent_tests()
     )}
  end

  def render(assigns) do
    Phoenix.View.render(DemoWeb.TypingTestView, "index.html", assigns)
  end

  def handle_params(%{"token" => token}, _path, socket) do
    token = String.to_atom(token)
    Stats.start_link(token)
    {:noreply, assign(socket, token: token)}
  end

  def handle_event("start", _, socket) do
    Stats.reset(socket.assigns.token)
    schedule_next_tick()
    input = ""

    {:noreply, assign(socket, status: "playing", prompt: get_prompt(input), input: input)}
  end

  def handle_event("update-input", %{"user_input" => input}, socket) do
    handle_input_event(socket.assigns.status, input, socket)
  end

  def handle_event("enter", %{"user_input" => input}, socket) do
    new_input = input <> "⏎"

    if String.length(new_input) + 1 == String.length(prompt_text()) do
      Process.cancel_timer(socket.assigns.timer_ref)
      Stats.reset(socket.assigns.token)
      History.log(socket.assigns.token, socket.assigns.wpm)

      DemoWeb.Endpoint.broadcast(
        "typing_test_results",
        "test_complete",
        %{
          id: socket.assigns.token,
          wpm: socket.assigns.wpm
        }
      )

      {:noreply,
       assign(socket,
         status: "waiting",
         prompt: get_prompt(""),
         wpm: socket.assigns.wpm
       )}
    else
      {:noreply, assign(socket, prompt: get_prompt(new_input), input: new_input)}
    end
  end

  def handle_info(:tick, socket) do
    timer_ref = schedule_next_tick()
    token = socket.assigns.token
    input_text = socket.assigns.input

    %{wpm: wpm, elapsed_time: elapsed_time} = Stats.update_wpm(token, input_text)

    {:noreply,
     assign(socket,
       timer_ref: timer_ref,
       elapsed_time: elapsed_time,
       wpm: wpm
     )}
  end

  def handle_info(%{event: "test_complete", payload: _result}, socket) do
    {:noreply, assign(socket, history: History.get_recent_tests())}
  end

  defp schedule_next_tick() do
    Process.send_after(self(), :tick, 1000)
  end

  defp handle_input_event("playing", input_text, socket) do
    %{wpm: wpm, elapsed_time: elapsed_time} =
      Stats.update_wpm(
        socket.assigns.token,
        input_text
      )

    {:noreply,
     assign(socket,
       prompt: get_prompt(input_text),
       wpm: wpm,
       elapsed_time: elapsed_time,
       input: input_text
     )}
  end

  defp handle_input_event(_status, _input_text, socket) do
    {:noreply, socket}
  end

  defp get_prompt(input_text) do
    prompt_text()
    |> Parse.tokenize(input_text)
  end

  defp prompt_text() do
    "In the early 1970s, David McNeill, a psychology professor at the University of Chicago, was giving a talk in a Paris lecture hall when something odd caught his eye.⏎ "
  end
end
