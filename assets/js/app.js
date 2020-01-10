import {Socket} from 'phoenix';
import LiveSocket from 'phoenix_live_view';
import css from '../css/app.css';
import 'phoenix_html';

let Hooks = {};
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

let liveSocket = new LiveSocket('/live', Socket, {hooks: Hooks});
liveSocket.connect();
