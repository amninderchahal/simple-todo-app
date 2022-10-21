export interface AuthUser {
    uid: string;
    email: string | null;
    displayName: string | null;
    photoURL: string | null;
};

export interface AuthError {
    code: number;
    message: string;
}