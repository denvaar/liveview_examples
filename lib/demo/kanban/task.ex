defmodule Demo.Kanban.Task do
  @enforce_keys [:id, :title, :status]
  defstruct [:id, :title, :status]

  def create(title) do
    %__MODULE__{
      id: generate_id(),
      title: title,
      status: 0
    }
  end

  def change_status(task, new_status) do
    %{task | status: new_status}
  end

  def change_title(task, new_title) do
    %{task | title: new_title}
  end

  defp generate_id() do
    seed = 6

    seed
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, seed)
  end
end
