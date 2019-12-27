defmodule DemoWeb.KanbanLive do
  use Phoenix.LiveView

  def mount(_session, socket) do
    initial_tasks =
      ["Here is a task", "Make a kanban app to demonstrate LiveView"]
      |> Enum.map(&Demo.Kanban.Task.create/1)

    {:ok, assign(socket, edit_id: nil, tasks: initial_tasks)}
  end

  def render(assigns) do
    DemoWeb.KanbanView.render("index.html", assigns)
  end

  def handle_event("create-task", _, socket) do
    tasks = socket.assigns.tasks
    new_task = Demo.Kanban.Task.create("")

    {:noreply, assign(socket, edit_id: new_task.id, tasks: [new_task | tasks])}
  end

  def handle_event("edit-task", %{"id" => t_id}, socket) do
    {:noreply, assign(socket, edit_id: t_id)}
  end

  def handle_event("add-title", %{"title" => title, "t_id" => task_id}, socket) do
    index =
      socket.assigns.tasks
      |> Enum.find_index(fn %{id: t_id} ->
        task_id == t_id
      end)

    tasks =
      socket.assigns.tasks
      |> List.update_at(index, fn task ->
        Demo.Kanban.Task.change_title(task, title)
      end)

    {:noreply, assign(socket, tasks: tasks, edit_id: nil)}
  end

  def handle_event("delete-task", %{"id" => task_id}, socket) do
    tasks =
      socket.assigns.tasks
      |> Enum.filter(fn %{id: t_id} ->
        t_id != task_id
      end)

    {:noreply, assign(socket, tasks: tasks)}
  end

  def handle_event("drop", %{"t_id" => task_id, "status" => status}, socket) do
    index =
      socket.assigns.tasks
      |> Enum.find_index(fn %{id: t_id} ->
        task_id == t_id
      end)

    tasks =
      socket.assigns.tasks
      |> List.update_at(index, fn task ->
        Demo.Kanban.Task.change_status(task, String.to_integer(status))
      end)

    {:noreply, assign(socket, tasks: tasks)}
  end
end
