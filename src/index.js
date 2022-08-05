import { Elm } from './App/Main.elm';
import { setupFirebasePorts } from './firebase/firebase-ports.ts';
import * as brandIcon from '../public/android-chrome-192x192.png';

const flags = {
  brandIcon
};

const app = Elm.App.Main.init({
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
