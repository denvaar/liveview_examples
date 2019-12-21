defmodule DemoWeb.FormValidationView do
  use DemoWeb, :view
  alias DemoWeb.Helpers
  import Demo.FormValidation.Validators, only: [form_is_valid?: 3, is_valid?: 1]

  def css_for(field_name, field_value) do
    Helpers.css(
      "is-success": field_value != "" && is_valid?({field_name, field_value}),
      "is-danger": field_value != "" && !is_valid?({field_name, field_value})
    )
  end

  def error_message(name, email, date) do
    [{:name, name}, {:email, email}, {:date, date}]
    |> Enum.filter(fn {_name, value} -> value != "" end)
    |> Enum.map(fn {name, _value} = field ->
      if is_valid?(field),
        do: "",
        else: "The #{name} field doesn't look quite right..."
    end)
    |> Enum.join(" ")
    |> String.trim()
  end

  def success_message(name, email, date) do
    [{:name, name}, {:email, email}, {:date, date}]
    |> Enum.all?(fn {_name, value} = field ->
      is_valid?(field) && value != ""
    end)
    |> make_success_message()
  end

  defp make_success_message(true), do: "Everything looks good 👌"
  defp make_success_message(_), do: ""
end
