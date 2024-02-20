import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth-service/auth.service';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})
export class NavbarComponent {
    @Input() showProfileImage: boolean = false;
    @Input() profileImageSrc: string | undefined;
    public isDropdownVisible: boolean = false;

    constructor(private authService: AuthService, private router: Router) {}

    toggleDropdown(): void {
        this.isDropdownVisible = !this.isDropdownVisible;
    }

    logout(): void {
        this.authService.logout();
        this.router.navigate(['/login']);
    }
}
