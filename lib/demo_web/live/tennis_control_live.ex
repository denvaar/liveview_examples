defmodule DemoWeb.TennisControlLive do
  use Phoenix.LiveView

  def mount(_session, socket) do
    matches = Demo.Tennis.Matches.get_matches()

    {:ok,
     assign(socket,
       matches: matches,
       creating_match: false,
       player_1: "",
       player_2: ""
     )}
  end

  def render(assigns) do
    form_is_valid? =
      String.length(assigns.player_1) > 0 &&
        String.length(assigns.player_2) > 0

    ~L"""
    <section class="hero is-medium is-info">
      <div class="hero-body">
        <div class="container">
          <form
            phx-submit="create-match"
            phx-change="check-is-form-valid">
            <div class="field is-grouped">
              <p class="control">
                <input
                class="input"
                type="text"
                name="player_1"
                value="<%= @player_1 %>"
                placeholder="Player one name">
              </p>
              <p class="control">
                <input
                class="input"
                type="text"
                name="player_2"
                value="<%= @player_2 %>"
                placeholder="Player two name">
              </p>
            </div>
            <%= if form_is_valid? do %>
              <button
                class="button is-info is-inverted is-outlined"
                phx-click="toggle-creating">
                Create Match
              </button>
            <% else %>
              <button
                disabled
                class="button is-info is-inverted is-outlined">
                Create Match
              </button>
            <% end %>
          </form>
        </div>
      </div>
    </section>
    <div class="section">
      <div class="container">
        <h4 class="title is-4">Tennis Matches</h4>
        <%= if length(@matches) == 0 do %>
          <p class="content is-small">
            <i>Create some and they will be listed here.</i>
          </p>
        <% end %>
        <div class="columns">
          <div class="column is-half">
            <%= for match <- @matches do %>
              <div class="box">
                <div class="columns is-mobile is-centered has-text-centered">
                  <div class="column is-half">
                    <h5 class="title is-5">
                      <%= match.player_1.name %>
                    </h5>
                    <button
                      phx-click="add-point"
                      phx-value-id="<%= match.id %>"
                      phx-value-player="player_1"
                      class="button is-small is-success is-light is-rounded">
                      + point
                    </button>
                  </div>
                  <div class="column">
                    <h5 class="title is-5">
                      <%= match.player_2.name %>
                    </h5>
                    <button
                      phx-click="add-point"
                      phx-value-id="<%= match.id %>"
                      phx-value-player="player_2"
                      class="button is-small is-success is-light is-rounded">
                      + point
                    </button>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("toggle-creating", _params, socket) do
    {:noreply, assign(socket, creating_match: !socket.assigns.creating_match)}
  end

  def handle_event(
        "check-is-form-valid",
        %{"player_1" => player_1, "player_2" => player_2},
        socket
      ) do
    {:noreply, assign(socket, player_1: player_1, player_2: player_2)}
  end

  def handle_event("create-match", %{"player_1" => player_1, "player_2" => player_2}, socket) do
    match = Demo.Tennis.Matches.create_match(player_1, player_2)

    {:noreply,
     assign(socket,
       matches: [match | socket.assigns.matches],
       player_1: "",
       player_2: ""
     )}
  end

  def handle_event("add-point", %{"id" => id, "player" => player}, socket) do
    Demo.Tennis.Matches.give_point(id, String.to_atom(player))

    {:noreply, socket}
  end
end
