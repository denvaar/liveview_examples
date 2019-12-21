defmodule Demo.FormValidation.Validators do
  def form_is_valid?(name, email, date) do
    [{:name, name}, {:email, email}, {:date, date}]
    |> Enum.map(&is_valid?(&1))
    |> Enum.all?(&(&1 == true))
  end

  def is_valid?({:name, name}) do
    word_count =
      name
      |> String.trim()
      |> String.split(" ")
      |> Enum.count()

    word_count >= 2
  end

  def is_valid?({:email, email}) do
    ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
    |> Regex.match?(email)
  end

  def is_valid?({:date, date}) do
    ~r/^(0[1-9]|[12][0-9]|3[01])[- \.\/](0[1-9]|1[012])[- \.\/](19|20)\d\d$/
    |> Regex.match?(date)
  end
end
