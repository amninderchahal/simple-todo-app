import { Elm } from './Main.elm';
import { setupFirebasePorts } from './firebase-ports.ts';
import * as brandIcon from '../public/android-chrome-192x192.png';

const flags = {
  brandIcon
};

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags
});

setupFirebasePorts(app);

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register(
    new URL('./service-worker.js', import.meta.url),
    { type: 'module' }
  );
}
