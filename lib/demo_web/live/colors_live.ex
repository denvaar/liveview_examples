defmodule DemoWeb.ColorsLive do
  use Phoenix.LiveView

  def mount(_session, socket) do
    if connected?(socket) do
      bubbles =
        create_random_bubbles()
        |> scale_bubbles()

      Process.send_after(self(), :tick, 1000)

      {:ok,
       assign(socket,
         bubbles: bubbles,
         target_x: nil,
         target_y: nil
       )}
    else
      {:ok, assign(socket, bubbles: [])}
    end
  end

  def render(assigns) do
    ~L"""
    <div id="colors" class="colors">
      <%= for bubble <- @bubbles do %>
        <div
          class="bubble"
          style="top:<%= bubble.y %>px;left:<%= bubble.x %>px;background:<%= bubble.color %>;">
        </div>
      <% end %>
    </div>
    """
  end

  def handle_info(:tick, socket) do
    bubbles = update_bubbles(socket.assigns.bubbles)

    if !all_done?(bubbles), do: Process.send_after(self(), :tick, 16)

    {:noreply, assign(socket, bubbles: bubbles)}
  end

  def create_random_bubbles() do
    1..1_000
    |> Enum.map(fn n ->
      color = gen_random_rgb()
      target_x = Demo.Colors.Sorting.hue_of_color(color)

      %{
        id: n,
        target_x: target_x,
        x: Enum.random(5..900),
        y: Enum.random(5..800),
        color: "rgb(#{color.r},#{color.g}, #{color.b});"
      }
    end)
  end

  def scale_bubbles(bubbles) do
    x_max =
      bubbles
      |> Enum.max_by(fn %{target_x: target_x} -> target_x end)
      |> Map.get(:target_x)

    x_min =
      bubbles
      |> Enum.min_by(fn %{target_x: target_x} -> target_x end)
      |> Map.get(:target_x)

    bubbles
    |> Enum.map(fn bubble ->
      scaled_target_x = (bubble.target_x - x_min) / (x_max - x_min) * (900 - 5) + 5
      %{bubble | target_x: scaled_target_x}
    end)
  end

  def x_factor(%{x: x, target_x: target_x}) when x < target_x do
    1
  end

  def x_factor(_), do: -1

  def update_bubble_x(diff, bubble) when diff <= 20 do
    bubble.x
  end

  def update_bubble_x(_diff, bubble) do
    2..15
    |> Enum.random()
    |> Kernel.*(x_factor(bubble))
    |> Kernel.+(bubble.x)
    |> max(0)
  end

  defp update_bubbles(bubbles) do
    bubbles
    |> Enum.map(fn bubble ->
      %{
        bubble
        | x:
            bubble.x
            |> Kernel.-(bubble.target_x)
            |> abs()
            |> update_bubble_x(bubble)
      }
    end)
  end

  defp all_done?(bubbles) do
    bubbles
    |> Enum.all?(fn %{target_x: target_x, x: x} ->
      abs(x - target_x) <= 20
    end)
  end

  defp gen_random_rgb() do
    r = Enum.random(0..255)
    g = Enum.random(0..255)
    b = Enum.random(0..255)

    %{r: r, g: g, b: b}
  end
end
