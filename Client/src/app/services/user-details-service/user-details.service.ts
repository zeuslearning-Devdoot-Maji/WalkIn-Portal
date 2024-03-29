import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class UserDetailsService {

    private apiBaseUrl = 'http://localhost:5193';

    constructor(private http: HttpClient) { }

    getUserDisplayPicture(): Observable<any> {
        const endpoint = `${this.apiBaseUrl}/api/User/DisplayPicture`

        // Retrieve the token from local storage
        const token = localStorage.getItem('token');

        const headers = new HttpHeaders({
            'Authorization': `Bearer ${token}`
        });

        return this.http.get<any>(endpoint, { headers });
    }
}
