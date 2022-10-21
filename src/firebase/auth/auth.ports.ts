import { Auth, GoogleAuthProvider, onAuthStateChanged, signInWithPopup, signOut } from "firebase/auth";
import { Firestore } from "firebase/firestore";
import { App } from "../types";

const provider = new GoogleAuthProvider();

function setUpSignInPort(app: App, auth: Auth): void {
    app.ports.signIn.subscribe(() => {
        console.log("LogIn called");
        signInWithPopup(auth, provider)
            .catch(error => {
                app.ports.signInError.send({
                    code: error.code,
                    message: error.message
                });
            });
    });
}

function setUpSignOutPort(app: App, auth: Auth): void {
    app.ports.signOut.subscribe(() => {
        console.log("LogOut called");
        signOut(auth);
    });
}

function setUpAuthChangedPort(app: App, auth: Auth, firestore: Firestore): void {
    onAuthStateChanged(auth, user => {
        console.log('Auth changed', user);
        app.ports.signInInfo.send(user);
    });
}

export function setupAuthPorts(app: App, auth: Auth, firestore: Firestore): void {
    setUpAuthChangedPort(app, auth, firestore);
    setUpSignInPort(app, auth);
    setUpSignOutPort(app, auth);
}

