defmodule Demo.TypingTest.Parse do
  def tokenize(prompt, ""), do: prompt

  def tokenize(prompt, input) do
    data =
      prompt
      |> split_into_letters()
      |> Enum.zip(split_into_letters(input))
      |> Enum.map(&compare_words(&1))
      |> Enum.with_index()
      |> Enum.reduce(%{result: "", last_token: nil, last_index: 0}, &to_html(&1, &2))

    data.result
    |> Kernel.<>("</span>" <> String.slice(prompt, (data.last_index + 1)..-1))
  end

  defp split_into_letters(text), do: String.graphemes(text)

  defp compare_words({letter_a, letter_b}) when letter_a == letter_b do
    {:complete, letter_a}
  end

  defp compare_words({letter_a, _}) do
    {:error, letter_a}
  end

  defp to_html({{token, letter}, index}, %{result: result, last_token: nil} = acc) do
    %{
      acc
      | last_index: index,
        last_token: token,
        result: result <> "<span class='#{token}'>" <> letter
    }
  end

  defp to_html({{token, letter}, index}, %{result: result, last_token: last_token} = acc)
       when last_token !== token do
    %{
      acc
      | last_index: index,
        last_token: token,
        result: result <> "</span><span class='#{token}'>" <> letter
    }
  end

  defp to_html({{_token, letter}, index}, %{result: result} = acc) do
    %{acc | last_index: index, result: result <> letter}
  end
end
