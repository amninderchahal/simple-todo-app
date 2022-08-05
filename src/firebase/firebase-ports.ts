import { initializeApp } from 'firebase/app';
import { getAuth, signInWithPopup, signOut, GoogleAuthProvider, onAuthStateChanged, User } from "firebase/auth";
import { query, getFirestore, collection, addDoc, onSnapshot } from "firebase/firestore";

interface PortsFromElm {
    signIn: PortFromElm<void>;
    signOut: PortFromElm<void>;
}

interface PortsToElm {
    signInInfo: PortToElm<{
        uid: string,
        email: string | null,
        displayName: string | null,
        photoURL: string | null
    } | null>;
    signInError: PortToElm<{
        code: number,
        message: string
    }>
}

type App = ElmApp<PortsFromElm & PortsToElm>;

const firebaseConfig = {
    apiKey: process.env.ELM_APP_FIREBASE_API_KEY,
    authDomain: process.env.ELM_APP_FIREBASE_AUTH_DOMAIN,
    projectId: process.env.ELM_APP_FIREBASE_PROJECT_ID,
    storageBucket: process.env.ELM_APP_FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.ELM_APP_FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.ELM_APP_FIREBASE_APP_ID
};

const firebaseApp = initializeApp(firebaseConfig);

const provider = new GoogleAuthProvider();
const auth = getAuth();
const db = getFirestore();

function setUpSignInPort(app: App): void {
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

function setUpSignOutPort(app: App): void {
    app.ports.signOut.subscribe(() => {
        console.log("LogOut called");
        signOut(auth);
    });
}

function setUpAuthChangedPort(app: App): void {
    onAuthStateChanged(auth, user => {
        console.log('Auth changed', user);
        app.ports.signInInfo.send(user);

/* // Set up listened on new messages
            const q = query(collection(db, `users/${user.uid}/messages`));
            onSnapshot(q, querySnapshot => {
                console.log("Received new snapshot");
                const messages = [];

                querySnapshot.forEach(doc => {
                    if (doc.data().content) {
                        messages.push(doc.data().content);
                    }
                });

                app.ports.receiveMessages.send({
                    messages: messages
                });
            }); */
    });
}

export function setupFirebasePorts(app: App): void {
    setUpAuthChangedPort(app);
    setUpSignInPort(app);
    setUpSignOutPort(app);
}

