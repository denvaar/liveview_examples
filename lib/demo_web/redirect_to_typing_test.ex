defmodule DemoWeb.RedirectToTypingTest do
  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Phoenix.Controller.redirect(to: "/typing-test/#{generate_token(5)}")
    |> Plug.Conn.halt()
  end

  defp generate_token(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
