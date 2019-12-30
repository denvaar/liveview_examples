defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DemoWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/counter", CounterLive, as: :counter

    live "/form-validation", FormValidationLive, as: :form_validation
    post "/process_form", FormValidationController, :post, as: :process_form
    get "/form-validation-thanks", FormValidationController, :index, as: :form_validation_thanks

    get "/typing-test", RedirectToTypingTest, as: :typing_test
    live "/typing-test/:token", TypingTestLive

    live "/kanban", KanbanLive, as: :kanban

    live "/tennis/watch", TennisLive, as: :watch_tennis
    live "/tennis/control", TennisControlLive, as: :tennis_control
  end
end
