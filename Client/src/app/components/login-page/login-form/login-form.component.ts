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

    credentials = {
        email: '',
        password: '',
        remember: false
    };

    constructor(private authService: AuthService, private router: Router) { }

    login() {
        console.log(this.credentials)
        // Call the login service
        this.authService.login(this.credentials).subscribe(
            (response) => {
                /* 
                 * Successful login
                 * Store the token in local storage or a secure storage method
                 */
                console.log(response)
                localStorage.setItem('token', response.token);

                // TODO: Redirect to the Job listing page
                this.router.navigate(['']);
            },
            (error) => {
                console.error('Login failed', error);
            }
        );
    }

    togglePasswordVisibility() {
        this.showPassword = !this.showPassword;
    }
}
