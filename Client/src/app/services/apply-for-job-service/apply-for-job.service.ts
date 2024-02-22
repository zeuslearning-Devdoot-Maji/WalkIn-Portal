import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class ApplyForJobService {

    private apiBaseUrl = 'http://localhost:5193';

    constructor(private http: HttpClient) { }

    applyForJob(jobId: string, selectedRoleIds: number[], selectedTimeSlotId: number): Observable<any> {
        const endpoint = `${this.apiBaseUrl}/api/jobs/${jobId}/Apply`

        // Retrieve the token from local storage
        const token = localStorage.getItem('token');

        const headers = new HttpHeaders({
            'Authorization': `Bearer ${token}`
        });

        const requestBody = {
            roleIds: selectedRoleIds,
            timeSlotId: selectedTimeSlotId
        };

        return this.http.post<any>(endpoint, requestBody, { headers });
    }

}
