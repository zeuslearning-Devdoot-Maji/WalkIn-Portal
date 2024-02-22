import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { UserDetailsService } from 'src/app/services/user-details-service/user-details.service';

@Component({
    selector: 'app-job-application-confirmation-page',
    templateUrl: './job-application-confirmation-page.component.html',
    styleUrls: ['./job-application-confirmation-page.component.css']
})
export class JobApplicationConfirmationPageComponent {
    jobId: string = '';
    displayPicture!: { displayPicture: string; };

    constructor(
        private userDetailsService: UserDetailsService,
        private router: Router
    ) { }

    ngOnInit(): void {
        this.getUserDisplayPicture();
    }

    getUserDisplayPicture() {
        this.userDetailsService.getUserDisplayPicture().subscribe(data => {
            this.displayPicture = data;
        });
    }

    navigateToJobsPage(): void {
        this.router.navigate(['/jobs']);
    }

}
