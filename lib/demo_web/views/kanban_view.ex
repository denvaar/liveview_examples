defmodule DemoWeb.KanbanView do
  use DemoWeb, :view

  def tasks_with_status(tasks, status) do
    tasks
    |> Enum.filter(fn %Demo.Kanban.Task{status: t_status} ->
      status == t_status
    end)
  end
end
