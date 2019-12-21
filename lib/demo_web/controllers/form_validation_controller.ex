defmodule DemoWeb.FormValidationController do
  use DemoWeb, :controller
  alias DemoWeb.Router.Helpers
  alias Demo.FormValidation.Validators

  def index(conn, _params) do
    render(conn, DemoWeb.FormValidationView, "thanks.html")
  end

  def post(conn, %{"name" => name, "email" => email, "date" => date}) do
    if Validators.form_is_valid?(name, email, date) do
      conn
      |> put_flash(:info, [name, email, date] |> Enum.join(", "))
      |> put_view(DemoWeb.FormValidationView)
      |> render("thanks.html")
    else
      redirect(conn,
        to:
          Helpers.form_validation_path(conn, DemoWeb.FormValidationLive,
            name: name,
            email: email,
            date: date
          )
      )
    end
  end
end
