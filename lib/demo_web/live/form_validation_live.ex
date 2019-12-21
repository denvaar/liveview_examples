defmodule DemoWeb.FormValidationLive do
  use Phoenix.LiveView
  alias DemoWeb.Router.Helpers
  alias Demo.FormValidation.Validators

  def mount(_session, socket) do
    {:ok,
     assign(socket,
       name: "",
       email: "",
       date: "",
       js_enabled: connected?(socket)
     )}
  end

  def render(assigns) do
    Phoenix.View.render(
      DemoWeb.FormValidationView,
      "index.html",
      assigns
    )
  end

  def handle_params(%{"name" => name, "email" => email, "date" => date}, _uri, socket) do
    {:noreply, assign(socket, name: name, email: email, date: date)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("input-change", %{"_target" => ["name"], "name" => name}, socket) do
    {:noreply, assign(socket, name: name)}
  end

  def handle_event("input-change", %{"_target" => ["email"], "email" => email}, socket) do
    {:noreply, assign(socket, email: email)}
  end

  def handle_event("input-change", %{"_target" => ["date"], "date" => date}, socket) do
    {:noreply, assign(socket, date: date)}
  end

  def handle_event("submit", %{"name" => name, "email" => email, "date" => date}, socket) do
    if Validators.form_is_valid?(name, email, date) do
      {:stop,
       socket
       |> put_flash(:info, [name, email, date] |> Enum.join(", "))
       |> redirect(to: Helpers.form_validation_thanks_path(DemoWeb.Endpoint, :index))}
    else
      {:noreply, socket}
    end
  end
end
