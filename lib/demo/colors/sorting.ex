defmodule Demo.Colors.Sorting do
  def sort_by_hue(colors) do
    colors
    |> Enum.sort(&hue_sort_callback/2)
  end

  def hue_of_color(%{r: r, g: g, b: b}) do
    hsv_values =
      [r, g, b]
      |> Enum.map(&(&1 / 255))

    get_hue(
      Enum.max(hsv_values),
      Enum.min(hsv_values),
      hsv_values
    )
  end

  defp hue_sort_callback(color_a, color_b) do
    hue_of_color(color_a) <= hue_of_color(color_b)
  end

  defp get_hue(max_hsv, min_hsv, [r, g, b]) when max_hsv > 0 do
    chr = max_hsv - min_hsv
    sat = chr / max_hsv

    cond do
      sat <= 0 ->
        0

      r == max_hsv ->
        60 * ((g - min_hsv - (b - min_hsv)) / chr)

      g == max_hsv ->
        120 + 60 * ((b - min_hsv - (r - min_hsv)) / chr)

      b == max_hsv ->
        240 + 60 * ((r - min_hsv - (g - min_hsv)) / chr)

      true ->
        0
    end
  end

  defp get_hue(_max_hsv, _min_hsv, _), do: 0
end
