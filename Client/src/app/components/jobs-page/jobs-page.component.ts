import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { JobsListingService } from 'src/app/services/jobs-listing-service/jobs-listing.service';
import { UserDetailsService } from 'src/app/services/user-details-service/user-details.service';

@Component({
    selector: 'app-jobs-page',
    templateUrl: './jobs-page.component.html',
    styleUrls: ['./jobs-page.component.css']
})
export class JobsPageComponent {

    jobs: any[] = [];
    displayPicture!: {displayPicture: string;};

    constructor(
        private jobsListingService: JobsListingService,
        private userDetailsService: UserDetailsService,
        private router: Router
    ) {}

    ngOnInit(): void {
        Promise.all([
            this.getJobsListingData(),
            this.getUserDisplayPicture()
        ]).then(([jobs, displayPicture]) => {
            this.jobs = jobs;
            this.displayPicture = displayPicture;
        }).catch(error => {
            console.error('Error fetching data', error);
        });
    }

    getJobsListingData(): Promise<any[]> {
        return new Promise((resolve, reject) => {
            this.jobsListingService.getJobsAvailableForUser().subscribe(
                data => resolve(data),
                error => reject(error)
            );
        });
    }

    getUserDisplayPicture(): Promise<{ displayPicture: string; }> {
        return new Promise((resolve, reject) => {
            this.userDetailsService.getUserDisplayPicture().subscribe(
                data => resolve(data),
                error => reject(error)
            );
        });
    }

    calculateDaysRemaining(endDate: string): number {
        const today = new Date();
        const end = new Date(endDate);

        const timeDifference = end.getTime() - today.getTime();
        return Math.ceil(timeDifference / (1000 * 3600 * 24));
    }

    navigateToJobDetails(jobId: string): void {
        this.router.navigate(['/jobs', jobId]);
    }

}
