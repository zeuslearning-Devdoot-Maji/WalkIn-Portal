import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth-service/auth.service';

@Component({
    selector: 'app-login-form',
    templateUrl: './login-form.component.html',
    styleUrls: ['./login-form.component.css']
})
export class LoginFormComponent {
    showPassword: boolean = false;
    errorMessage: string = '';

    credentials = {
        email: '',
        password: '',
        remember: false
    };

    constructor(private authService: AuthService, private router: Router) { }

    login() {
        this.authService.login(this.credentials).subscribe({
            next: (response) => {
                /* 
                 * Successful login
                 * Store the token in local storage or a secure storage method
                 */
                localStorage.setItem('token', response.token);

                this.router.navigate(['/jobs']);
            },
            error: (error) => {
                console.error('Login failed', error);
                this.errorMessage = 'Invalid Email ID or Password. Please try again.';
            }
        });       
    }

    togglePasswordVisibility() {
        this.showPassword = !this.showPassword;
    }
}
