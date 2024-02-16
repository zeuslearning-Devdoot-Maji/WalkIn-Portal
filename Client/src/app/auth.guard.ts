import { Injectable } from '@angular/core';
import { Router } from '@angular/router';

@Injectable({
    providedIn: 'root',
})
export class AuthGuard {
    constructor(private router: Router) { }

    canActivate(): boolean {
        // Check if the user is authenticated
        const isAuthenticated = localStorage.getItem('token') !== null;

        if (!isAuthenticated) {
            // Redirect to the login page if not authenticated
            this.router.navigate(['/login']);
        }

        return isAuthenticated;
    }
}
