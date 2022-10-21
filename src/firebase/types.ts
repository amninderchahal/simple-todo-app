import { AuthError, AuthUser } from "./auth/auth.types";

interface PortsFromElm {
    signIn: PortFromElm<void>;
    signOut: PortFromElm<void>;
}

interface PortsToElm {
    signInInfo: PortToElm<AuthUser | null>;
    signInError: PortToElm<AuthError>
}

export type App = ElmApp<PortsFromElm & PortsToElm>;
