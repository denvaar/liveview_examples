# Kanban Board

There's some cases where you just have to use JavaScript. LiveView offers [hooks](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#module-javascript-client-specific) for these special cases. I think that drag and drop is one instance where adding a hook is necessary. This app is a very dumbed-down version of a tool like Asana that just allows users to create, remove, and move task cards around on a kanban board.

There's no new concepts in [the LiveView module](/lib/demo_web/live/kanban_live.ex) for this app, but there's some JavaScript code [here](/assets/js/app.js) that we can look at.

Hooks are JavaScript objects. They have a few different life-cycle callbacks and also contain some attributes and functions within their scope that allows you to interact with the server-side LiveView module in a manual way.

In this kanban app, we want the ability to drag cards into columns, which should change the status of the task. So, I created a hook for each card by adding `phx-hook="kanbanCard"` along with `phx-value-id="<%= task.id %>"` to the markup for a task [in the leex template file](/lib/demo_web/templates/kanban/column.html.leex).

Next, I added the corresponding hook object:

```
Hooks.KanbanCard = {
  mounted() {
    const cards = document.querySelectorAll('.k-card');

    cards.forEach(card => {
      card.addEventListener('dragstart', e => {
        e.dataTransfer.setData('t_id', e.target.getAttribute('phx-value-id'));
        e.dataTransfer.setData(
          'status',
          e.target.parentElement.parentElement.getAttribute('phx-value-status'),
        );
      });
    });
  },
};
```

This hook will add "dragstart" event listeners to every card element on the page. Next, I added another hook to handle the "drop" event for each column on the page, following the same process.

```
Hooks.KanbanColumn = {
  mounted() {
    this.el.addEventListener('dragover', e => {
      e.preventDefault();
    });

    this.el.addEventListener('drop', e => {
      const taskId = e.dataTransfer.getData('t_id');
      const taskStatus = e.dataTransfer.getData('status');

      if (taskId && taskStatus) {
        this.pushEvent('drop', {t_id: taskId, status: taskStatus});
      }
    });
  },
};
```

So, in summary, often times you won't need to use hooks, but for some cases, they are necessary.
