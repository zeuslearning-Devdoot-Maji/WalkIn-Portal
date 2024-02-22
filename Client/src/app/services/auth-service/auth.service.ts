import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

    private apiBaseUrl = 'http://localhost:5193';

    constructor(private http: HttpClient) { }

    login(credentials: { email: string; password: string }): Observable<any> {
        const endpoint = `${this.apiBaseUrl}/api/Account/Login`
        return this.http.post(endpoint, credentials);
    }

    logout(): void {
        localStorage.removeItem('token');
    }
}
