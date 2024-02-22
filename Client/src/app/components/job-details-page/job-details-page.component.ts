import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ApplyForJobService } from 'src/app/services/apply-for-job-service/apply-for-job.service';
import { JobDetailsService } from 'src/app/services/job-details-service/job-details.service';
import { UserDetailsService } from 'src/app/services/user-details-service/user-details.service';

@Component({
    selector: 'app-job-details-page',
    templateUrl: './job-details-page.component.html',
    styleUrls: ['./job-details-page.component.css']
})

export class JobDetailsPageComponent {
    job: any = {};
    jobId: string = '';
    displayPicture!: { displayPicture: string; };
    showPrerequisiteSection: boolean = false;
    showRoleDetails: boolean[] = [];
    selectedTimeSlot: number | null = null;
    selectedRoleIds: number[] = [];

    constructor(
        private jobDetailsService: JobDetailsService,
        private userDetailsService: UserDetailsService,
        private jobApplicationService: ApplyForJobService,
        private route: ActivatedRoute,
        private router: Router
    ) { }

    ngOnInit(): void {
        this.route.params.subscribe(params => {
            this.jobId = params['jobId'];

            Promise.all([
                this.getJobDetails(),
                this.getUserDisplayPicture()
            ]).then(([job, displayPicture]) => {
                this.job = job;
                this.displayPicture = displayPicture;
            }).catch(error => {
                console.error('Error fetching data', error);
            });
        });
    }

    getJobDetails(): Promise<any> {
        return new Promise((resolve, reject) => {
            this.jobDetailsService.getJobDetails(this.jobId).subscribe(
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

    togglePrerequisiteSection(): void {
        this.showPrerequisiteSection = !this.showPrerequisiteSection;
    }

    toggleRoleDetailsSection(i: number): void {
        this.showRoleDetails[i] = !this.showRoleDetails[i];
    }

    applyForJob(): void {
        if (this.selectedTimeSlot && this.selectedRoleIds.length > 0) {
            this.jobApplicationService.applyForJob(this.jobId, this.selectedRoleIds, this.selectedTimeSlot)
                .subscribe(
                    () => {
                        this.router.navigate(['/jobs/:jobId/confirmation']);
                    },
                    error => {
                        alert('Failed to apply for the job. Please try again.');
                        console.error('Error applying for the job', error);
                    }
                );
        } else {
            alert('Please select a time slot and at least one role before applying.');
            console.warn('Please select a time slot and at least one role before applying.');
        }
    }

    onCheckboxChange(event: any, roleId: number) {
        if (event.target.checked) {
            this.selectedRoleIds.push(roleId);
        } else {
            const index = this.selectedRoleIds.indexOf(roleId);
            if (index > -1) {
                this.selectedRoleIds.splice(index, 1);
            }
        }
    }

}
