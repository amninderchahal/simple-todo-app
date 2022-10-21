import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from "firebase/firestore";
import { setupAuthPorts } from './auth/auth.ports';
import { App } from './types';

const firebaseConfig = {
    apiKey: process.env.ELM_APP_FIREBASE_API_KEY,
    authDomain: process.env.ELM_APP_FIREBASE_AUTH_DOMAIN,
    projectId: process.env.ELM_APP_FIREBASE_PROJECT_ID,
    storageBucket: process.env.ELM_APP_FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.ELM_APP_FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.ELM_APP_FIREBASE_APP_ID
};

const firebaseApp = initializeApp(firebaseConfig);
const firestore = getFirestore(firebaseApp);
const auth = getAuth();


export function setupFirebasePorts(app: App): void {
    setupAuthPorts(app, auth, firestore);
}
