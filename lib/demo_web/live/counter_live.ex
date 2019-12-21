defmodule DemoWeb.CounterLive do
  use Phoenix.LiveView

  @max_count 10

  def mount(_sesssion, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def render(assigns) do
    max_count = @max_count

    percentage =
      assigns.count
      |> Kernel.*(10)
      |> Integer.to_string()
      |> Kernel.<>("%")

    ~L"""
    <div class="columns is-mobile is-centered">
      <div class="column is-half">
        <section class="section has-text-centered">
          <div class="container">
            <h1 class="title is-1"><%= @count %></h1>
            <div class="level">
              <div class="level-left">
                <%= if @count == 0 do %>
                  <button
                    class="button is-info"
                    phx-click="change-count"
                    disabled
                    value="-1">
                  -
                  </button>
                <% else %>
                  <button
                    class="button is-info"
                    phx-click="change-count"
                    value="-1">
                  -
                  </button>
                <% end %>
              </div>
              <div class="level-right">
                <%= if @count == max_count do %>
                  <button
                    class="button is-info"
                    phx-click="change-count"
                    disabled
                    value="1">
                  +
                  </button>
                <% else %>
                  <button
                    class="button is-info"
                    phx-click="change-count"
                    value="1">
                  +
                  </button>
                <% end %>
              </div>
            </div>
          </div>
          <div class="container mt-20">
            <div class="meter">
              <span style="width: <%= percentage %>;"></span>
            </div>
          </div>
        </section>
      </div>
    </div>
    """
  end

  def handle_event("change-count", %{"value" => value}, socket) do
    value = String.to_integer(value)

    new_count =
      socket.assigns.count
      |> Kernel.+(value)
      |> Kernel.min(10)
      |> Kernel.max(0)

    {:noreply, assign(socket, count: new_count)}
  end
end
