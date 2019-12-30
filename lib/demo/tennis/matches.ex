defmodule Demo.Tennis.Matches do
  use GenServer

  alias Demo.Tennis.Scoring

  @match_list "tennis_matches"

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def create_match(player_1, player_2) do
    GenServer.call(__MODULE__, {:create, player_1, player_2})
  end

  def give_point(match_id, player) do
    GenServer.cast(__MODULE__, {:point, match_id, player})
  end

  def get_matches() do
    GenServer.call(__MODULE__, :list)
  end

  def subscribe_to_match_list() do
    DemoWeb.Endpoint.subscribe(@match_list)
  end

  def subscribe_to_match(match_id) do
    DemoWeb.Endpoint.subscribe(match_id)

    GenServer.call(__MODULE__, :list)
    |> Enum.find(fn %{id: id} ->
      match_id == id
    end)
  end

  def unsubscribe_from_match(match_id) do
    DemoWeb.Endpoint.unsubscribe(match_id)
  end

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_cast({:point, id, player}, matches) do
    index = match_index(matches, id)

    match = Enum.at(matches, index)
    updated_match = Scoring.add_point(match, player)
    matches = List.update_at(matches, index, fn _ -> updated_match end)

    DemoWeb.Endpoint.broadcast(id, "score_updated", %{match: Enum.at(matches, index)})

    {:noreply, matches}
  end

  @impl true
  def handle_call(:list, _from, matches), do: {:reply, matches, matches}

  def handle_call({:create, player_1, player_2}, _from, matches) do
    new_match = %{
      id: player_1 <> player_2,
      serving: :player_1,
      winner: nil,
      player_1: %{
        sets: [0],
        name: player_1,
        score: 0,
        games_won: 0
      },
      player_2: %{
        sets: [0],
        name: player_2,
        score: 0,
        games_won: 0
      }
    }

    matches = [new_match | matches]

    DemoWeb.Endpoint.broadcast(@match_list, "match_added", %{matches: matches})

    {:reply, new_match, matches}
  end

  defp match_index(matches, id) do
    matches
    |> Enum.find_index(fn match -> match.id == id end)
  end
end
