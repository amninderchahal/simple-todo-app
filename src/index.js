import '../public/styles/main.scss';
import { Elm } from './Main.elm';
import { setupFirebasePorts } from './firebase-interop.ts';
import * as serviceWorker from './serviceWorker';

const app = Elm.Main.init({
  node: document.getElementById('root')
});

setupFirebasePorts(app);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
