import {Socket} from 'phoenix';
import LiveSocket from 'phoenix_live_view';
import css from '../css/app.css';
import 'phoenix_html';

let liveSocket = new LiveSocket('/live', Socket);
liveSocket.connect();
