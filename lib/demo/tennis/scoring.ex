defmodule Demo.Tennis.Scoring do
  def add_point(match, player) do
    player_1 = player_attrs(match, :player_1)
    player_2 = player_attrs(match, :player_2)
    index = if player == :player_1, do: 0, else: 1

    {player_1.score, player_2.score}
    |> inc_score(index)
    |> handle_score_change(match, player)
  end

  defp player_attrs(match_attrs, player) do
    Map.get(match_attrs, player)
  end

  defp handle_score_change({0, 0}, match, player) do
    # game complete
    winning_player = player_attrs(match, player)
    loosing_player = player_attrs(match, other_player(player))

    games_won = winning_player.games_won + 1
    diff = abs(games_won - loosing_player.games_won)

    set_complete? = games_won >= 6 && diff >= 2

    updated_sets =
      List.update_at(winning_player.sets, length(winning_player.sets) - 1, fn x ->
        x + 1
      end)

    updated_sets = if set_complete?, do: updated_sets ++ [0], else: updated_sets
    loosing_sets = if set_complete?, do: loosing_player.sets ++ [0], else: loosing_player.sets

    updated_games_won = if set_complete?, do: 0, else: games_won
    loosing_games_won = if set_complete?, do: 0, else: loosing_player.games_won

    match
    |> Map.merge(%{serving: other_player(match.serving)})
    |> Map.put(player, %{
      winning_player
      | sets: updated_sets,
        games_won: updated_games_won,
        score: 0
    })
    |> Map.put(other_player(player), %{
      loosing_player
      | sets: loosing_sets,
        games_won: loosing_games_won,
        score: 0
    })
  end

  defp handle_score_change({score_1, score_2}, match, _player) do
    match
    |> Map.put(:player_1, %{match.player_1 | score: score_1})
    |> Map.put(:player_2, %{match.player_2 | score: score_2})
  end

  defp other_player(:player_1), do: :player_2
  defp other_player(:player_2), do: :player_1

  defp inc_score({0, b}, 0), do: {15, b}
  defp inc_score({15, b}, 0), do: {30, b}
  defp inc_score({30, b}, 0), do: {40, b}
  defp inc_score({40, 40}, 0), do: {"AD", 40}
  defp inc_score({40, "AD"}, 0), do: {40, 40}

  defp inc_score({a, 0}, 1), do: {a, 15}
  defp inc_score({a, 15}, 1), do: {a, 30}
  defp inc_score({a, 30}, 1), do: {a, 40}
  defp inc_score({40, 40}, 1), do: {40, "AD"}
  defp inc_score({"AD", 40}, 1), do: {40, 40}

  defp inc_score(_, _), do: {0, 0}
end
